defmodule KlziiChat.Services.DirectMessageTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.DirectMessageService
  import Ecto

  test "DirectMessage - can create message", %{ facilitator: facilitator, participant: participant, session: session } do
    params = %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "Aaa" }
    {:ok, resp } = DirectMessageService.create_message(session.id, params)

    assert(resp.text == params["text"])
    assert(resp.senderId == params["senderId"])
    assert(resp.recieverId == params["recieverId"])
    assert(resp.sessionId == session.id)
  end

  test "DirectMessage - should return all messages", %{ facilitator: facilitator, participant: participant, session: session } do
    { :ok, unread_message } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "Aaa" })

    read_message = build_assoc(
      session, :direct_messages,
      senderId: participant.id,
      recieverId: facilitator.id,
      readAt: Timex.DateTime.now,
      text: "Bbb"
    )
    |> Repo.insert!
    %{ "read" => read_list, "unread" => unread_list } = DirectMessageService.get_all_direct_messages(facilitator.id)

    assert(read_list == [read_message])
    assert(unread_list == [unread_message])
  end

  test "DirectMessage - set all messages as read", %{ facilitator: facilitator, participant: participant, session: session } do
    { :ok, message1 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "Aaa" })
    { :ok, message2 } = DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "Bbb" })
    { :ok, message3 } = DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => "Ccc" })

    %{ "unread" => unread_list } = DirectMessageService.get_all_direct_messages(participant.id)
    assert(unread_list == [message3, message2, message1])

    resp = DirectMessageService.set_all_messages_read(participant.id)
    %{ "unread" => unread_list, "read" => read_list } = DirectMessageService.get_all_direct_messages(participant.id)

    assert(unread_list == [message3])
    # assert(read_list == [message2, message1])
  end

  test "DirectMessage - get unread message count", %{ facilitator: facilitator, participant: participant, session: session } do
    DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "Aaa" })
    DirectMessageService.create_message(session.id, %{ "senderId" => facilitator.id, "recieverId" => participant.id, "text" => "Bbb" })

    count = DirectMessageService.get_unread_count(participant.id)
    |> Map.get(to_string(facilitator.id))
    assert(count == 2)

    resp = DirectMessageService.get_unread_count(facilitator.id)
    assert(resp == %{})
  end

  test "DirectMessage - get last messages", %{ facilitator: facilitator, participant: participant, session: session, participant2: participant2 } do
    DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => "Aaa" })
    DirectMessageService.create_message(session.id, %{ "senderId" => participant.id, "recieverId" => facilitator.id, "text" => "Bbb" })

    DirectMessageService.create_message(session.id, %{ "senderId" => participant2.id, "recieverId" => facilitator.id, "text" => "Ccc" })
    DirectMessageService.create_message(session.id, %{ "senderId" => participant2.id, "recieverId" => facilitator.id, "text" => "Ddd" })

    messages = DirectMessageService.get_last_messages(facilitator.id)
    assert(Map.get(messages, to_string(participant.id)) == "Bbb")
    assert(Map.get(messages, to_string(participant2.id)) == "Ddd")
  end
end
