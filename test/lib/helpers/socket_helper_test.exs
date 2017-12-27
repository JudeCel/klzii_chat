defmodule KlziiChat.Helpers.SocketHelperTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Helpers.SocketHelper

  test "get_session_member" do
    session_member =  %{session_id: 1, account_user_id: 1, account_user: %{}}
    socket =   Phoenix.Socket.assign(Phoenix.Socket.__struct__, :session_member, %{session_id: 1, account_user_id: 1})
    assert(SocketHelper.get_session_member(socket) == session_member)
  end
end
