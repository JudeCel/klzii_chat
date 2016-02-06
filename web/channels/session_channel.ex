defmodule KlziiChat.SessionChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.Services.SessionService

  # This Channel is only for session context
  # Session Member information
  # Global messages for session

  def join("sessions:" <> session_id, payload, socket) do
    if authorized?(socket) do
      assign(socket, :session_id, session_id)
      send(self, :after_join)
      case SessionService.find(session_id) do
        {:ok, session} ->
          {:ok, session, socket}
        {:error, reason} ->
          {:error, %{reason: reason}}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    push socket, "self_info", socket.assigns.session_member
    {:noreply, socket}
  end

  # # This is invoked every time a notification is being broadcast
  # # to the client. The default implementation is just to push it
  # # downstream but one could filter or change the event.
  # def handle_out(event, payload, socket) do
  #   push socket, event, payload
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(socket) do
    is_map(socket.assigns.session_member)
  end
end
