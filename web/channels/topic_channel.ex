defmodule KlziiChat.TopicChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{TopicsService, EventsService, WhiteboardService}

  # This Channel is only for Topic context
  # brodcast and receive messages from session members
  # History for specific topic

  def join("topics:" <> topic_id, payload, socket) do
    if authorized?(socket) do
      session_member = socket.assigns.session_member
      case EventsService.history(topic_id, "message", session_member.id) do
        {:ok, history} ->
          {:ok, history, assign(socket, :topic_id, String.to_integer(topic_id))}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  def handle_in("whiteboardHistory", payload, socket) do
    case WhiteboardService.history(socket.assigns.topic_id, "object") do
      {:ok, history} ->
        {:reply, {:ok, %{history: history}}, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("new_message", payload, socket) do
    topic_id = socket.assigns.topic_id
    case EventsService.create_message(socket.assigns.session_member.id, topic_id, payload) do
      {:ok, event} ->
        broadcast! socket, "new_message", event
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("delete_message", %{ "id" => id }, socket) do
    case EventsService.deleteById(id) do
      {:ok, resp} ->
        broadcast! socket, "delete_message", resp
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("message_star", %{"id" => id}, socket) do
    session_member_id = socket.assigns.session_member.id
    case EventsService.star(id, session_member_id) do
      {:ok, event} ->
        broadcast! socket, "message_star", event
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("thumbs_up", %{"id" => id}, socket) do
    session_member_id = socket.assigns.session_member.id
    case EventsService.thumbs_up(id, session_member_id) do
      {:ok, event} ->
        broadcast! socket, "message_star", event
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("update_message", %{"id" => id, "body" => body}, socket) do
    session_member_id = socket.assigns.session_member.id
    case EventsService.update_message(id, body, session_member_id) do
      {:ok, event} ->
        broadcast! socket, "message_star", event
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("draw", payload, socket) do
    session_member_id = socket.assigns.session_member.id
    topic_id = socket.assigns.topic_id
    case WhiteboardService.create_object(session_member_id, topic_id,  payload) do
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
    case WhiteboardService.update_object(session_member_id, topic_id,  object) do
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

  # Add authorization logic here as required.
  # TODO: Need verification by topic and session context.
  defp authorized?(socket) do
    is_map(socket.assigns.session_member)
  end
end
