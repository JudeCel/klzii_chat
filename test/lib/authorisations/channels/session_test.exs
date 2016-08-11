defmodule KlziiChat.Authorisations.Channels.SessionTest do
  use KlziiChat.{ChannelCase, SessionMemberCase}
  alias KlziiChat.Authorisations.Channels.Session

  test "Session authorisation succses #authorized?", %{facilitator: facilitator} do
    session_member = %{session_id: facilitator.sessionId, id: facilitator.id}
    socket =   Phoenix.Socket.assign(Phoenix.Socket.__struct__, :session_member, session_member)
    assert({:ok} = Session.authorized?(socket, session_member.session_id))
  end

  test "Session authorisation fails #authorized?", %{facilitator: facilitator} do
    session_member = %{session_id: facilitator.sessionId, id: facilitator.id}
    socket =   Phoenix.Socket.assign(Phoenix.Socket.__struct__, :session_member, session_member)
    assert({:error, _} = Session.authorized?(socket, session_member.session_id + 1))
  end
end
