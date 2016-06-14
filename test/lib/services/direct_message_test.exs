defmodule KlziiChat.Services.DirectMessageTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.DirectMessageService

  test "DirectMessage - can create message", %{ facilitator: facilitator, participant: participant, session: session } do
    params = %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "Aaa" }
    {:ok, resp } = DirectMessageService.create_message(session.id, params)

    assert(resp.text == params["text"])
    assert(resp.senderId == params["senderId"])
    assert(resp.recieverId == params["recieverId"])
    assert(resp.sessionId == session.id)
  end

end
