defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.SessionService
  alias KlziiChat.Services.SessionMembersService
  alias KlziiChat.{SessioPresence ,SessionMembersView}

  # This Channel is only for session context
  # Session Member information
  # Global messages for session
  intercept ["member_entered", "member_left"]

  def join("sessions:" <> session_id, payload, socket) do
    {session_id, _} = Integer.parse(session_id)
    if authorized?(socket) do
      send(self, :after_join)
      case SessionService.find(session_id) do
        {:ok, session} ->
          {:ok, session, assign(socket, :session_id, session_id)}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    case SessionMembersService.by_session(socket.assigns.session_id) do
      {:ok, members} ->
        push socket, "members", members
        {:ok, _} = SessioPresence.track(socket, (socket.assigns.session_member.id |> to_string), %{
          online_at: inspect(System.system_time(:seconds))
        })
        push socket, "presence_state", SessioPresence.list(socket)
        push(socket, "self_info", SessionMembersView.render("current_member.json", member: socket.assigns.session_member))

      {:error, reason} ->
        {:error, %{reason: reason}}
    end


    {:noreply, socket}
  end

  def handle_in("update_member", params, socket) do
    case SessionMembersService.update_member(socket.assigns.session_member.id, params) do
      {:ok, session_member} ->
        broadcast socket, "update_member", session_member
        push(socket, "self_info", SessionMembersView.render("current_member.json", member: session_member)) # Update current user context
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_out(event, payload, socket) do
    if socket.assigns.session_member.id != payload.id  do
      push socket, event, payload
    end
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket) do
    is_map(socket.assigns.session_member)
  end
end
