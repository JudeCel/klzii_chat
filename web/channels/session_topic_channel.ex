defmodule KlziiChat.SessionTopicChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{MessageService, UnreadMessageService, ConsoleService, SessionTopicService}
  alias KlziiChat.{MessageView, Presence, Endpoint, ConsoleView, SessionTopicView, SessionMembersView}
  import(KlziiChat.Authorisations.Channels.SessionTopic, only: [authorized?: 2])
  import(KlziiChat.Helpers.SocketHelper, only: [get_session_member: 1])


  @moduledoc """
    This Channel is only for Session Topic context brodcast and receive messages from session members
    History for specific session topic
  """

  intercept ["new_message", "update_message", "update_message", "thumbs_up"]

  def join("session_topic:" <> session_topic_id, _payload, socket) do
    if authorized?(socket, session_topic_id) do
      socket = assign(socket, :session_topic_id, String.to_integer(session_topic_id))
      send(self, :after_join)
      case MessageService.history(session_topic_id, get_session_member(socket)) do
        {:ok, history} ->
          {:ok, history, socket}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    session_member = get_session_member(socket)
    {:ok, console} = ConsoleService.get(session_member.session_id, socket.assigns.session_topic_id)
    {:ok, _} = Presence.track(socket, (get_session_member(socket).id |> to_string), %{
      online_at: inspect(System.system_time(:seconds)),
      id: session_member.id,
      role: session_member.role
    })

    UnreadMessageService.delete_unread_messages_for_topic(session_member.id, socket.assigns.session_topic_id)
    messages = UnreadMessageService.sync_state(session_member.id)
    Endpoint.broadcast!("sessions:#{session_member.session_id}", "unread_messages", messages)
    push socket, "console", ConsoleView.render("show.json", %{console: console})
    {:noreply, socket}
  end

  def handle_in("board_message", payload, socket) do
    session_topic_id = socket.assigns.session_topic_id
    session_member = get_session_member(socket)
    if String.length(payload["message"]) > 0  do
      case SessionTopicService.board_message(session_member.id, session_topic_id, payload) do
        {:ok, session_topic} ->
          broadcast!(socket, "board_message",  SessionTopicView.render("show.json", %{session_topic: session_topic}))
          {:reply, :ok, socket}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "Message too short"}}
    end
  end

  def handle_in("set_console_resource", %{"id" => id}, socket) do
    case ConsoleService.set_resource(get_session_member(socket).id, socket.assigns.session_topic_id, id) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("remove_console_resource", %{"type" => type}, socket) do
    case ConsoleService.remove_resource(get_session_member(socket).id, socket.assigns.session_topic_id, type) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("new_message", payload, socket) do
    session_topic_id = socket.assigns.session_topic_id
    session_member = get_session_member(socket)
    if String.length(payload["body"]) > 0  do
      case MessageService.create_message(session_member, session_topic_id, payload) do
        {:ok, message} ->
          KlziiChat.BackgroundTasks.Message.new(message.id)
          broadcast!(socket, "new_message",  message)
          Endpoint.broadcast!("sessions:#{message.session_member.sessionId}", "update_member", SessionMembersView.render("member.json", member: message.session_member))
          {:reply, :ok, socket}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "Message too short"}}
    end
  end

  def handle_in("delete_message", %{ "id" => id }, socket) do
    case MessageService.deleteById(get_session_member(socket), id) do
      {:ok, resp} ->
        session_member = get_session_member(socket)
        KlziiChat.BackgroundTasks.Message.delete(session_member.session_id, socket.assigns.session_topic_id)
        broadcast! socket, "delete_message", resp
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("message_star", %{"id" => id}, socket) do
    session_member = get_session_member(socket)
    case MessageService.star(id, session_member) do
      {:ok, message} ->
        {:reply, {:ok, MessageView.render("show.json", %{message: message, member: session_member}) }, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("thumbs_up", %{"id" => id}, socket) do
    case MessageService.thumbs_up(id, get_session_member(socket)) do
      {:ok, message} ->
        broadcast! socket, "update_message", message
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("update_message", %{"id" => id, "body" => body, "emotion" => emotion}, socket) do
    case MessageService.update_message(id, body, emotion, get_session_member(socket)) do
      {:ok, message} ->
        broadcast! socket, "update_message", message
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_out(message, payload, socket) do
    session_member = get_session_member(socket)
    push socket, message, MessageView.render("show.json", %{message: payload, member: session_member})
    {:noreply, socket}
  end
end
