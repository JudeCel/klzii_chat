defmodule KlziiChat.Authorisations.Channels.Session do
  def authorized?(socket, sesssion_id) do
    socket.assigns.session_member.session_id == sesssion_id
  end
end
