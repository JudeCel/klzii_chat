defmodule KlziiChat.WhiteboardChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.{ ShapeView }
  alias KlziiChat.Services.{ WhiteboardService}
  import(KlziiChat.Helpers.SocketHelper, only: [get_session_member: 1])
  import(KlziiChat.Authorisations.Channels.SessionTopic, only: [authorized?: 2])


  @moduledoc """
      This channel is for whiteboard events.
      whiteboard id is session topic id.
  """

  intercept ["draw", "update"]

  def join("whiteboard:" <> session_topic_id, _payload, socket) do
    if authorized?(socket, session_topic_id) do
      session_member = get_session_member(socket)
      socket = assign(socket, :session_topic_id, String.to_integer(session_topic_id))
      case WhiteboardService.history(socket.assigns.session_topic_id, session_member.id) do
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
    session_member = get_session_member(socket)
    session_topic_id = socket.assigns.session_topic_id
    case WhiteboardService.create_object(session_member.id, session_topic_id,  payload) do
      {:ok, shape} ->
        broadcast!(socket, "draw", shape)
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("update", %{"object" => object}, socket) do
    session_member = get_session_member(socket)
    session_topic_id = socket.assigns.session_topic_id

    case WhiteboardService.update_object(session_member.id, session_topic_id,  object) do
      {:ok, shape} ->
        broadcast!(socket, "update", shape)
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("delete", %{"uid" => uid}, socket) do
    case WhiteboardService.deleteByUids([uid]) do
      {:ok} ->
        broadcast!(socket, "delete", %{uid: uid})
        {:reply, :ok, socket}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:noreply, socket}
  end

  def handle_in("deleteAll", _, socket) do
    session_topic_id = socket.assigns.session_topic_id
    WhiteboardService.deleteAll(session_topic_id)
    broadcast!(socket, "deleteAll", %{})
    {:reply, :ok, socket}
  end

  def handle_out(message, payload, socket) do
    session_member = get_session_member(socket)
    push(socket, message, ShapeView.render("show.json", %{shape: payload, member: session_member}))
    # |> IO.inspect
    {:noreply, socket}
  end
end
