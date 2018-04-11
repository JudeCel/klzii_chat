defmodule KlziiChat.Channels.SessionTopic.MessageTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, UserSocket, SessionTopicChannel, SessionChannel}

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    session_topic_1_name =  "session_topic:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    { :ok, jwt2, _encoded_claims } =  Guardian.encode_and_sign(participant)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket2} = connect(UserSocket, %{"token" => jwt2})

    message = Ecto.build_assoc(
      participant, :messages,
      sessionTopicId: session_topic_1.id,
      body: "test",
      emotion: 1
    ) |> Repo.insert!

    Ecto.build_assoc(
      message, :unread_messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      createdAt: DateTime.utc_now,
      updatedAt: DateTime.utc_now
    ) |> Repo.insert!

    {:ok, socket: socket, socket2: socket2, session_topic_1_name: session_topic_1_name, message_id: message.id, session: session, session_topic_1: session_topic_1}
  end

  test "when unauthorized", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:error,  %{reason: "unauthorized"}} = join(socket, SessionTopicChannel, session_topic_1_name <> "2233")
  end

  test "can push new message", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
      body = "hey!!"
      ref = push socket, "new_message", %{"emotion" => "1", "body" => body}
      assert_reply ref, :ok
      assert_push "new_message", message
      assert(message.body == body)
  end

  test "can start message and unstart message", %{socket: socket, socket2: socket2, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    {:ok, _, socket2} = subscribe_and_join(socket2, SessionTopicChannel, session_topic_1_name)
      body = "hey!!"
      ref = push socket2, "new_message", %{"emotion" => "1", "body" => body}
      assert_reply ref, :ok
      assert_push "new_message", message

      # star message
      ref_star = push socket, "message_star", %{"id" => message.id}
      assert_reply ref_star, :ok, message_star
      assert(message_star.star)
      # unstar message
      ref_star = push socket, "message_star", %{"id" => message.id}
      assert_reply ref_star, :ok, message_star
      refute(message_star.star)
  end

  test "can push delete message", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
      ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
      assert_reply ref, :ok
      assert_push "new_message", message

      ref2 = push socket, "delete_message", %{"id" => message.id}
      assert_reply ref2, :ok

      assert_push "delete_message", resp
      assert(resp == %{id: message.id, replyId: nil})
  end

  test "can thumbs up for message", %{socket: socket, socket2: socket2, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    {:ok, _, socket2} = subscribe_and_join(socket2, SessionTopicChannel, session_topic_1_name)
    ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}

    assert_reply ref, :ok
    assert_push "new_message", message

    ref2 = push socket2, "thumbs_up", %{"id" => message.id}
    assert_reply ref2, :ok

    assert_push "update_message", resp
    assert(resp.has_voted)
  end

  test "can reply", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    message_body = "hey!!"

    message_ref = push socket, "new_message", %{"emotion" => "1", "body" => message_body}
    assert_reply message_ref, :ok
    assert_push "new_message", message
    assert(message.body == message_body)

    reply_body = "replyId body"
    reply_ref = push socket, "new_message", %{"emotion" => "1", "replyId" => message.id, "body" => reply_body}
    assert_reply reply_ref, :ok
    assert_push("new_message", %{body: "replyId body", replyId: message_id })
    assert(message_id == message.id)
  end

  test "read message", %{socket: socket, session_topic_1_name: session_topic_1_name, message_id: message_id} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    read_ref = push socket, "read_message", %{ id: message_id }
    assert_reply(read_ref, :ok)
  end

  test "update has messages when first message", %{socket: socket, session_topic_1_name: session_topic_1_name, session: session, session_topic_1: session_topic_1} do
    session_channel_name =  "sessions:" <> Integer.to_string(session.id)
    {:ok, _, _} = subscribe_and_join(socket, SessionChannel, session_channel_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    assert_push "self_info", _
    ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
    assert_reply ref, :ok
    assert_push "self_info", self_info
    hasMessages = get_in(self_info.sessionTopicContext, [Integer.to_string(session_topic_1.id), "hasMessages"])
    assert(hasMessages)
  end

  test "update has messages when remove only message", %{socket: socket, session_topic_1_name: session_topic_1_name, session: session, session_topic_1: session_topic_1} do
    session_channel_name =  "sessions:" <> Integer.to_string(session.id)
    {:ok, _, _} = subscribe_and_join(socket, SessionChannel, session_channel_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    assert_push "self_info", _
    ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
    assert_reply ref, :ok
    assert_push "new_message", message
    assert_push "self_info", _
    ref2 = push socket, "delete_message", %{"id" => message.id}
    assert_reply ref2, :ok
    assert_push "self_info", self_info
    hasMessages = get_in(self_info.sessionTopicContext, [Integer.to_string(session_topic_1.id), "hasMessages"])
    assert(!hasMessages)
  end

  test "can typing message", %{socket: socket, session_topic_1_name: session_topic_1_name, session: session, session_topic_1: session_topic_1} do
    session_channel_name =  "sessions:" <> Integer.to_string(session.id)
    {:ok, _, _} = subscribe_and_join(socket, SessionChannel, session_channel_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    ref = push socket, "typing_message", %{"typing" => true}
    assert_reply ref, :ok

    assert_push "typing_message", resp
    assert(resp.typing)
  end

  test "can set session topic active", %{socket: socket, session_topic_1_name: session_topic_1_name, session: session, session_topic_1: session_topic_1} do
    session_channel_name =  "sessions:" <> Integer.to_string(session.id)
    {:ok, _, _} = subscribe_and_join(socket, SessionChannel, session_channel_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)

    ref = push socket, "set_session_topic_active", %{"active" => false, "id" => session_topic_1.id}
    assert_reply ref, :ok
  end
end
