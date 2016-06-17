defmodule KlziiChat.Services.SessionServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionService

  test "can find session and return {:ok, session}", %{session: session} do
    {:ok, found_session} = SessionService.find_active(session.id)
    assert(found_session.id == session.id)
  end

  test "can't find session and return {:error, 'error message'}", %{session: session} do
    {:error, message} = SessionService.find_active(session.id + 99)
    assert(message == "Session not found")
  end
end
