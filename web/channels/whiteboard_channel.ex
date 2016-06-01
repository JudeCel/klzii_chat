defmodule KlziiChat.WhiteboardChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.{ WhiteboardService}

  @moduledoc """
      This channel is for whiteboard events.
      whiteboard id is session topic id.
  """

  def join("whiteboard:" <> session_topic_id, _payload, socket) do
    if authorized?(socket) do
      session_member = socket.assigns.session_member
      socket = assign(socket, :session_topic_id, String.to_integer(session_topic_id))
      case WhiteboardService.history(socket.assigns.session_topic_id) do
        {:ok, history} ->
          {:ok, history, socket}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "unauthorized"}}
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

  def handle_in("update", %{"object" => object}, socket) do
    session_member_id = socket.assigns.session_member.id
    session_topic_id = socket.assigns.session_topic_id

    case WhiteboardService.update_object(session_member_id, session_topic_id,  object) do
      {:ok, shape} ->
        broadcast! socket, "update", shape
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("delete", %{"uid" => uid}, socket) do
    case WhiteboardService.deleteByUids([uid]) do
      {:ok} ->
        broadcast! socket, "delete", %{uid: uid}
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("deleteAll", _, socket) do
    session_topic_id = socket.assigns.session_topic_id
    WhiteboardService.deleteAll(session_topic_id)
    broadcast! socket, "deleteAll", %{}
    {:reply, :ok, socket}
  end

  # Add authorization logic here as required.
  # TODO: Need verification by topic and session context.
  defp authorized?(socket) do
    is_map(socket.assigns.session_member)
  end
end
