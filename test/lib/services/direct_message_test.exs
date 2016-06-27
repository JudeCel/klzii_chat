defmodule KlziiChat.Services.DirectMessageTest do
  use KlziiChat.{ ModelCase, SessionMemberCase }
  alias KlziiChat.Services.DirectMessageService
  alias KlziiChat.{DirectMessage}

  @message_text1 "AAA"
  @message_text2 "BBB"
  @message_text3 "CCC"
  @message_text4 "DDD"

  test "DirectMessage - can create message", %{ facilitator: facilitator, participant: participant, session: session } do
    params = %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => @message_text1 }
    {:ok, resp } = DirectMessageService.create_message(session.id, params)

    assert(resp.text == params["text"])
    assert(resp.senderId == params["senderId"])
    assert(resp.recieverId == params["recieverId"])
    assert(resp.sessionId == session.id)
  end

  test "DirectMessage - cannot create message because sending to participant", %{ participant: participant, participant2: participant2, session: session } do
    params = %{ "senderId" => participant2.id, "recieverId" => participant.id, "text" => @message_text1 }
    {:error, error } = DirectMessageService.create_message(session.id, params)
    assert(error == "Action not allowed!")
  end

  test "DirectMessage - should return all messages", %{ facilitator: facilitator, participant: participant, session: session } do
    { :ok, message1 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => @message_text1 })
    { :ok, message2 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => @message_text2 })
    { :ok, message3 } = DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => @message_text3 })

    %{ "read" => read_list, "unread" => unread_list } = DirectMessageService.get_all_direct_messages(facilitator.id, participant.id, 0)

    assert(read_list == [message1, message2])
    assert(unread_list == [message3])
  end

  test "DirectMessage - set all messages as read", %{ facilitator: facilitator, participant: participant, session: session } do
    { :ok, message1 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => @message_text1 })
    { :ok, message2 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => @message_text2 })
    { :ok, message3 } = DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => @message_text3 })

    %{ "unread" => unread_list, "read" => read_list } = DirectMessageService.get_all_direct_messages(participant.id, facilitator.id, 0)
    assert(unread_list == [message1, message2])
    assert(read_list == [message3])

    :ok = DirectMessageService.set_all_messages_read(participant.id, facilitator.id)
    %{ "read" => read_list } = DirectMessageService.get_all_direct_messages(participant.id, facilitator.id, 0)

    message1 = Repo.get!(DirectMessage, message1.id)
    message2 = Repo.get!(DirectMessage, message2.id)
    message3 = Repo.get!(DirectMessage, message3.id)

    assert(read_list == [message1, message2, message3])
  end

  test "DirectMessage - get unread message count", %{ facilitator: facilitator, participant: participant, session: session } do
    DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => @message_text1 })
    DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => @message_text2 })

    count = DirectMessageService.get_unread_count(participant.id)
    |> Map.get(to_string(facilitator.id))
    assert(count == 2)

    resp = DirectMessageService.get_unread_count(facilitator.id)
    assert(resp == %{})
  end

  test "DirectMessage - get last messages", %{ facilitator: facilitator, participant: participant, session: session, participant2: participant2 } do
    DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => @message_text1 })
    DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => @message_text2 })

    DirectMessageService.create_message(session.id, %{ "senderId" => participant2.id, "recieverId" => facilitator.id, "text" => @message_text3 })
    DirectMessageService.create_message(session.id, %{ "senderId" => participant2.id, "recieverId" => facilitator.id, "text" => @message_text4 })

    messages = DirectMessageService.get_last_messages(facilitator.id)
    message_1 = Map.get(messages, to_string(participant.id))
    message_2 = Map.get(messages, to_string(participant2.id))
    assert(message_1.text == @message_text2)
    assert(message_2.text == @message_text4)
  end
end
