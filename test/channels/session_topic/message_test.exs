defmodule KlziiChat.Channels.SessionTopic.MessageTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, UserSocket, SessionTopicChannel}

  setup %{session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    session_topic_1_name =  "session_topic:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    { :ok, jwt2, _encoded_claims } =  Guardian.encode_and_sign(participant)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket2} = connect(UserSocket, %{"token" => jwt2})

    {:ok, socket: socket, socket2: socket2, session_topic_1_name: session_topic_1_name}
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

  test "can start message and unstart message", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
      body = "hey!!"
      ref = push socket, "new_message", %{"emotion" => "1", "body" => body}
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

  test "can reply ", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    message_body = "hey!!"

    message_ref = push socket, "new_message", %{"emotion" => "1", "body" => message_body}
    assert_reply message_ref, :ok
    assert_push "new_message", message
    assert(message.body == message_body)

    reply_body = "replyId body"
    reply_ref = push socket, "new_message", %{"emotion" => "1", "replyId" => message.id, "body" => reply_body}
    assert_reply reply_ref, :ok
    assert_push("new_message", %{body: "@cool member replyId body", replyId: message_id })
    assert(message_id == message.id)
  end
end
