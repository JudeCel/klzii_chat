defmodule KlziiChat.SessionsBuilderChannel do
  use KlziiChat.Web, :channel

  def join("sessionsBuilder:" <> session_id, _, socket) do
    {session_id, _} = Integer.parse(session_id)
      send(self, :after_join)
      {:ok, assign(socket, :session_id, session_id)}
  end

  def handle_info(:after_join, socket) do
    {:noreply, socket}
  end
end
