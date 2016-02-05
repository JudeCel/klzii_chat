defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.EventsService

  intercept ["new_message"]

  def join("sessions:" <> session_id, payload, socket) do
    if authorized?(socket) do
      assign(socket, :session_id, session_id)
      {:ok, socket.assigns.session_member, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_message", payload, socket) do
    case EventsService.create(socket.assigns.session_member.id, payload) do
      {:ok, entry} ->
        broadcast! socket, "new_message", entry
        {:reply, :ok, socket}
      {:error, _reason} ->
    end
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:reply, {:ok, payload}, socket}
    # {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(socket) do
    is_map(socket.assigns.session_member)
  end
end
