defmodule KlziiChat.TopicChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{TopicsService, EventsService}

  # This Channel is only for Topic context
  # brodcast and receive messages from session members
  # History for specific topic

  intercept ["new_message"]

  def join("topics:" <> topic_id, payload, socket) do
    if authorized?(socket) do
      case TopicsService.history(topic_id, "message") do
        {:ok, history} ->
          {:ok, history, assign(socket, :topic_id, topic_id)}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("whiteboardHistory", payload, socket) do
    case TopicsService.history(socket.assigns.topic_id, "object") do
      {:ok, history} ->
        {:reply, {:ok, %{history: history}}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("new_message", payload, socket) do
    case EventsService.create_message(socket.assigns.session_member.id, payload) do
      {:ok, event} ->
        broadcast! socket, "new_message", event
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("draw", payload, socket) do
    session_member_id = socket.assigns.session_member.id
    topic_id = socket.assigns.topic_id
    case EventsService.create_object(session_member_id, topic_id,  payload) do
      {:ok, event} ->
        broadcast! socket, "draw", event
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("update_object", %{"object" => object}, socket) do
    session_member_id = socket.assigns.session_member.id
    topic_id = socket.assigns.topic_id
    case EventsService.update_object(session_member_id, topic_id,  object) do
      {:ok, event} ->
        broadcast! socket, "update_object", event
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("delete_object", %{"uid" => uid}, socket) do
    session_member_id = socket.assigns.session_member.id
    topic_id = socket.assigns.topic_id
    case EventsService.deleteByUids([uid]) do
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
    EventsService.deleteAll(session_member_id, topic_id,  payload)
    broadcast! socket, "delete_all", %{}
    {:reply, :ok, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end



  # Add authorization logic here as required.
  # TODO: Need verification by topic and session context.
  defp authorized?(socket) do
    is_map(socket.assigns.session_member)
  end
end
