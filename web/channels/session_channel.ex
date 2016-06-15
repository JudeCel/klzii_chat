defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{SessionService, SessionMembersService, DirectMessageService}
  alias KlziiChat.Services.Permissions.Builder, as: PermissionsBuilder
  alias KlziiChat.{Presence, SessionMembersView, DirectMessageView}
  import(KlziiChat.Authorisations.Channels.Session, only: [authorized?: 2])
  import(KlziiChat.Helpers.SocketHelper, only: [get_session_member: 1])

  @moduledoc """
    This Channel is only for session context
    Session Member information
    Global messages for session
  """

  intercept ["unread_messages"]

  def join("sessions:" <> session_id, _, socket) do
    {session_id, _} = Integer.parse(session_id)
    if authorized?(socket, session_id) do
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
      {:error, reason} ->
        {:error, %{reason: reason}}
    end

      {:ok, _} = Presence.track(socket, (get_session_member(socket).id |> to_string), %{
        online_at: inspect(System.system_time(:seconds)),
        id: get_session_member(socket).id,
        role: get_session_member(socket).role
      })
      push socket, "presence_state", Presence.list(socket)
      push(socket, "self_info", get_session_member(socket))
    {:noreply, socket}
  end

  def handle_in("update_member", params, socket) do
    case SessionMembersService.update_member(get_session_member(socket).id, params) do
      {:ok, session_member} ->
        permision_task = Task.async(fn ->
          permissions = PermissionsBuilder.member_permissions(session_member.id)
          push(socket, "self_info", SessionMembersView.render("current_member.json", member: session_member, permissions_map: permissions))
        end)

        broadcast(socket, "update_member", SessionMembersView.render("member.json", member: session_member))
        Task.await(permision_task)
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("get_all_direct_messages", %{ "recieverId" => recieverId }, socket) do
    senderId = get_session_member(socket).id

    messages = DirectMessageService.get_all_direct_messages(recieverId, senderId)
    {:reply, {:ok, %{ messages: DirectMessageView.render("messages.json", messages: messages) }}, socket}
  end

  def handle_in("create_direct_message", %{ "recieverId" => recieverId, "text" => text }, socket) do
    sender_member = get_session_member(socket)

    { :ok, message } = DirectMessageService.create_message(sender_member.session_id, %{ "recieverId" => recieverId, "text" => text, "senderId" => sender_member.id })
    {:reply, { :ok, %{ message: DirectMessageView.render("show.json", message: message) } }, socket}
  end

  def handle_in("set_read_direct_messages", %{ "senderId" => senderId }, socket) do
    reciever_member = get_session_member(socket)

    DirectMessageService.set_all_messages_read(reciever_member.id, senderId)
    {:reply, :ok, socket}
  end

  def handle_out("unread_messages", payload, socket) do
    id = get_session_member(socket).id |> to_string
    case Map.get(payload, id, nil) do
      map when is_map(map) ->
        push socket, "unread_messages", map
      nil ->
        nil
    end
    {:noreply, socket}
  end
end
