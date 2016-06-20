defmodule KlziiChat.Services.DirectMessageTest do
  use KlziiChat.{ ModelCase, SessionMemberCase }
  alias KlziiChat.Services.DirectMessageService

  test "DirectMessage - can create message", %{ facilitator: facilitator, participant: participant, session: session } do
    params = %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "AAA" }
    {:ok, resp } = DirectMessageService.create_message(session.id, params)

    assert(resp.text == params["text"])
    assert(resp.senderId == params["senderId"])
    assert(resp.recieverId == params["recieverId"])
    assert(resp.sessionId == session.id)
  end

  test "DirectMessage - should return all messages", %{ facilitator: facilitator, participant: participant, session: session } do
    { :ok, message1 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "AAA" })
    { :ok, message2 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "BBB" })
    { :ok, message3 } = DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => "CCC" })

    %{ "read" => read_list, "unread" => unread_list } = DirectMessageService.get_all_direct_messages(facilitator.id, participant.id, 0)

    assert(read_list == [message2, message1])
    assert(unread_list == [message3])
  end

  test "DirectMessage - set all messages as read", %{ facilitator: facilitator, participant: participant, session: session } do
    { :ok, message1 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "AAA" })
    { :ok, message2 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "BBB" })
    { :ok, message3 } = DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => "CCC" })

    %{ "unread" => unread_list, "read" => read_list } = DirectMessageService.get_all_direct_messages(participant.id, facilitator.id, 0)
    assert(unread_list == [message2, message1])
    assert(read_list == [message3])

    :ok = DirectMessageService.set_all_messages_read(participant.id, facilitator.id)
    %{ "read" => read_list } = DirectMessageService.get_all_direct_messages(participant.id, facilitator.id, 0)

    message1 = Repo.get!(KlziiChat.DirectMessage, message1.id)
    message2 = Repo.get!(KlziiChat.DirectMessage, message2.id)
    message3 = Repo.get!(KlziiChat.DirectMessage, message3.id)

    assert(read_list == [message2, message1, message3])
  end

  test "DirectMessage - get unread message count", %{ facilitator: facilitator, participant: participant, session: session } do
    DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "AAA" })
    DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "BBB" })

    count = DirectMessageService.get_unread_count(participant.id)
    |> Map.get(to_string(facilitator.id))
    assert(count == 2)

    resp = DirectMessageService.get_unread_count(facilitator.id)
    assert(resp == %{})
  end

  test "DirectMessage - get last messages", %{ facilitator: facilitator, participant: participant, session: session, participant2: participant2 } do
    DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => "AAA" })
    DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => "BBB" })

    DirectMessageService.create_message(session.id, %{ "senderId" => participant2.id, "recieverId" => facilitator.id, "text" => "CCC" })
    DirectMessageService.create_message(session.id, %{ "senderId" => participant2.id, "recieverId" => facilitator.id, "text" => "DDD" })

    messages = DirectMessageService.get_last_messages(facilitator.id)
    assert(Map.get(messages, to_string(participant.id)) == "BBB")
    assert(Map.get(messages, to_string(participant2.id)) == "DDD")
  end
end
