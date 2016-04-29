defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.SessionService
  alias KlziiChat.Services.SessionMembersService

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
    case SessionMembersService.update_online_status(socket.assigns.session_member.id, true)  do
      {:ok, session_memeber} ->
        socket = assign(socket, :session_member, session_memeber)
      _->
        nil
    end

    broadcast socket, "member_entered", socket.assigns.session_member
    push(socket, "self_info", Map.put(socket.assigns.session_member, :jwt, buildJWT(socket.assigns.session_member)))
    case SessionMembersService.by_session(socket.assigns.session_id) do
      {:ok, members} ->
        push socket, "members", members
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("update_member", params, socket) do
    case SessionMembersService.update_member(socket.assigns.session_member.id, params) do
      {:ok, sessionMember} ->
        broadcast socket, "update_member", sessionMember
        push(socket, "self_info", sessionMember) # Update current user context
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  # Need implemented presences logic for multiple nodes, and topics scope.
  def terminate({reason, action}, socket) do
    case SessionMembersService.update_online_status(socket.assigns.session_member.id, false)  do
      {:ok, session_memeber} ->
        socket = assign(socket, :session_member, session_memeber)
      _ ->
        nil
    end
    broadcast socket, "member_left", socket.assigns.session_member
    :ok
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

  @spec buildJWT(Map.t) :: Map.t
  defp buildJWT(member) do
    { :ok, jwt, encoded_claims } =  Guardian.encode_and_sign(%KlziiChat.SessionMember{id: member.id})
    jwt
  end
end
