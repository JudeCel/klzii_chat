defmodule KlziiChat.Helpers.SocketHelper do
  
  @spec get_session_member(%Phoenix.Socket{}) :: Map.t
  def get_session_member(socket) do
    socket.assigns.session_member
  end
end