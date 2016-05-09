defmodule KlziiChat.TopicChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{MessageService, WhiteboardService, ResourceService, UnreadMessageService}
  alias KlziiChat.{MessageView, Presence, Endpoint}

  # This Channel is only for Topic context
  # brodcast and receive messages from session members
  # History for specific topic

  intercept ["new_message", "update_message", "update_message", "thumbs_up"]

  def join("topics:" <> topic_id, _payload, socket) do
    if authorized?(socket) do
      session_member = socket.assigns.session_member
      socket = assign(socket, :topic_id, String.to_integer(topic_id))
      send(self, :after_join)
      case MessageService.history(topic_id, session_member) do
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
    {:ok, _} = Presence.track(socket, (socket.assigns.session_member.id |> to_string), %{
      online_at: inspect(System.system_time(:seconds)),
      id: session_member.id,
      role: session_member.role
    })

    UnreadMessageService.delete_unread_messages_for_topic(session_member.id, socket.assigns.topic_id)
    unread_messages = UnreadMessageService.get_unread_messages([session_member.id])
    id = "#{session_member.id}"
    case unread_messages do
      messages  when messages == %{} ->
        empty_messages =  %{id =>  %{"topics" => %{}, "summary" => %{"normal" => 0, "reply" => 0 }}}
        Endpoint.broadcast!("sessions:#{session_member.session_id}", "unread_messages", empty_messages)
      messages->
        Endpoint.broadcast!("sessions:#{session_member.session_id}", "unread_messages", messages)
    end
    {:noreply, socket}
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
    topic_id = socket.assigns.topic_id
    session_member = socket.assigns.session_member
    if String.length(payload["body"]) > 0  do
      case MessageService.create_message(session_member, topic_id, payload) do
        {:ok, message} ->
          unread_message = Task.async(fn ->
            UnreadMessageService.process_new_message(session_member.session_id, topic_id, message.id)
          end)
          broadcast! socket, "new_message",  message
          Task.await(unread_message)
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
          topic_id = socket.assigns.topic_id
          session_member = socket.assigns.session_member
          UnreadMessageService.process_delete_message(session_member.session_id, topic_id, resp.id)
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

  def handle_in("update_message", %{"id" => id, "body" => body}, socket) do
    case MessageService.update_message(id, body, socket.assigns.session_member) do
      {:ok, message} ->
        broadcast! socket, "update_message", message
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("whiteboardHistory", _payload, socket) do
    case WhiteboardService.history(socket.assigns.topic_id) do
      {:ok, history} ->
        {:reply, {:ok, %{history: history} }, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("draw", payload, socket) do
    session_member_id = socket.assigns.session_member.id
    topic_id = socket.assigns.topic_id
    case WhiteboardService.create_object(session_member_id, topic_id,  payload) do
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
    topic_id = socket.assigns.topic_id
    case WhiteboardService.update_object(session_member_id, topic_id,  object) do
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
    WhiteboardService.deleteAll(session_member_id, topic_id,  payload)
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
