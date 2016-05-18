defmodule KlziiChat.SessionTopicChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{MessageService, WhiteboardService, ResourceService,
    UnreadMessageService, ConsoleService, SessionTopicService}
  alias KlziiChat.{MessageView, Presence, Endpoint, ConsoleView, SessionTopicView}

  # This Channel is only for Topic context
  # brodcast and receive messages from session members
  # History for specific topic

  intercept ["new_message", "update_message", "update_message", "thumbs_up"]

  def join("session_topic:" <> session_topic_id, _payload, socket) do
    if authorized?(socket) do
      session_member = socket.assigns.session_member
      socket = assign(socket, :session_topic_id, String.to_integer(session_topic_id))
      send(self, :after_join)
      case MessageService.history(session_topic_id, session_member) do
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
    session_member = socket.assigns.session_member
    {:ok, console} = ConsoleService.get(session_member.session_id, socket.assigns.session_topic_id)
    {:ok, _} = Presence.track(socket, (socket.assigns.session_member.id |> to_string), %{
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
    session_member = socket.assigns.session_member
    if String.length(payload["message"]) > 0  do
      case SessionTopicService.board_message(session_member.id, session_topic_id, payload) do
        {:ok, session_topic} ->
          broadcast!(socket, "board_message",  SessionTopicView.render("show.json", %{session_topic: session_topic}))
          # TODO need move to GenEvent handler
          new_message = %{"emotion" => 1, "body" => session_topic.boardMessage}
          case MessageService.create_message(session_member, session_topic_id, new_message) do
            {:ok, message} ->
              UnreadMessageService.process_new_message(session_member.session_id, session_topic_id, message.id)
              broadcast!(socket, "new_message",  message)
              {:reply, :ok, socket}
            {:error, reason} ->
              {:error, %{reason: reason}}
          end
          {:reply, :ok, socket}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "Message too short"}}
    end
  end

  def handle_in("set_console_resource", %{"id" => id}, socket) do
    case ConsoleService.set_resource(socket.assigns.session_member.id, socket.assigns.session_topic_id, id) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("remove_console_resource", %{"type" => type}, socket) do
    case ConsoleService.remove_resource(socket.assigns.session_member.id, socket.assigns.session_topic_id, type) do
      {:ok, console} ->
        broadcast! socket, "console",  ConsoleView.render("show.json", %{console: console})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("resources", %{"type" => type}, socket) do
    case ResourceService.get(socket.assigns.session_member.account_user_id, type) do
      {:ok, resources} ->
        {:reply, {:ok, %{type: type, resources: resources}}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("deleteResources", %{"id" => id}, socket) do
    case ResourceService.deleteByIds(socket.assigns.session_member.account_user_id, [id]) do
      {:ok, resources} ->
        {:reply, {:ok, %{ id: List.first(resources).id, type: List.first(resources).type }}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("new_message", payload, socket) do
    session_topic_id = socket.assigns.session_topic_id
    session_member = socket.assigns.session_member
    if String.length(payload["body"]) > 0  do
      case MessageService.create_message(session_member, session_topic_id, payload) do
        {:ok, message} ->
          # TODO need move to GenEvent handler
          UnreadMessageService.process_new_message(session_member.session_id, session_topic_id, message.id)
          broadcast!(socket, "new_message",  message)
          {:reply, :ok, socket}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "Message too short"}}
    end
  end

  def handle_in("delete_message", %{ "id" => id }, socket) do
    case MessageService.deleteById(socket.assigns.session_member, id) do
      {:ok, resp} ->
        unread_message = Task.async(fn ->
          session_topic_id = socket.assigns.session_topic_id
          session_member = socket.assigns.session_member
          UnreadMessageService.process_delete_message(session_member.session_id, session_topic_id)
        end)
        broadcast! socket, "delete_message", resp
        Task.await(unread_message)
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("message_star", %{"id" => id}, socket) do
    session_member = socket.assigns.session_member
    case MessageService.star(id, session_member) do
      {:ok, message} ->
        {:reply, {:ok, MessageView.render("show.json", %{message: message, member: session_member}) }, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("thumbs_up", %{"id" => id}, socket) do
    case MessageService.thumbs_up(id, socket.assigns.session_member) do
      {:ok, message} ->
        broadcast! socket, "update_message", message
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("update_message", %{"id" => id, "body" => body, "emotion" => emotion}, socket) do
    case MessageService.update_message(id, body, emotion, socket.assigns.session_member) do
      {:ok, message} ->
        broadcast! socket, "update_message", message
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("whiteboardHistory", _payload, socket) do
    case WhiteboardService.history(socket.assigns.session_topic_id, socket.assigns.session_member) do
      {:ok, history} ->
        {:reply, {:ok, %{history: history} }, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("draw", payload, socket) do
    session_member_id = socket.assigns.session_member.id
    session_topic_id = socket.assigns.session_topic_id
    case WhiteboardService.create_object(session_member_id, session_topic_id,  payload) do
      {:ok, shape} ->
        broadcast! socket, "draw", shape
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("update_object", %{"object" => object}, socket) do
    session_member_id = socket.assigns.session_member.id
    session_topic_id = socket.assigns.session_topic_id
    case WhiteboardService.update_object(session_member_id, session_topic_id,  object) do
      {:ok, shape} ->
        broadcast! socket, "update_object", shape
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("delete_object", %{"uid" => uid}, socket) do
    case WhiteboardService.deleteByUids([uid]) do
      {:ok} ->
        broadcast! socket, "delete_object", %{uid: uid}
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("deleteAll", payload, socket) do
    session_member_id = socket.assigns.session_member.id

    topic_id = socket.assigns.topic_id
    WhiteboardService.deleteAll(session_member_id, topic_id)
    broadcast! socket, "delete_all", %{}
    {:reply, :ok, socket}
  end

  def handle_out(message, payload, socket) do
    session_member = socket.assigns.session_member
    push socket, message, MessageView.render("show.json", %{message: payload, member: session_member})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  # TODO: Need verification by topic and session context.
  defp authorized?(socket) do
    is_map(socket.assigns.session_member)
  end
end
