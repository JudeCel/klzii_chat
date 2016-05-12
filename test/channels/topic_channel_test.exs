defmodule KlziiChat.TopicChannelTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, Presence, UserSocket, TopicChannel}

  setup %{topic_1: topic_1, session: session, session: session, member: member, member2: member2} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    topic_1_name =  "topics:" <> Integer.to_string(topic_1.id)
    {:ok, socket} = connect(UserSocket, %{"token" => member.token})
    {:ok, socket2} = connect(UserSocket, %{"token" => member2.token})
    {:ok, socket: socket, socket2: socket2, topic_1_name: topic_1_name}
  end

  test "receive empty console on subscribing", %{socket: socket, topic_1_name: topic_1_name} do
    {:ok, _, _} = subscribe_and_join(socket, TopicChannel, topic_1_name)
    assert_push("console", %{})
  end

  test "set resource to console", %{account_user: account_user, socket: socket, topic_1_name: topic_1_name} do
    {:ok, resource} = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert

    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, topic_1_name)
    ref = push socket, "set_console_resource", %{"id" => resource.id}
    assert_reply ref, :ok
    assert_push("console", %{})
  end

  test "remove resource from console ", %{account_user: account_user, socket: socket, topic_1_name: topic_1_name} do
    {:ok, resource} = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert

    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, topic_1_name)
    ref = push socket, "remove_console_resource", %{"id" => resource.id}
    assert_reply ref, :ok
    assert_push("console", %{})
  end

  test "presents register is enable for topics", %{socket: socket, topic_1_name: topic_1_name} do
    {:ok, _, socket} =
      join(socket, TopicChannel, topic_1_name)
      session_member = socket.assigns.session_member

      id = Presence.list(socket)
        |> Map.get(session_member.id |> to_string)
        |> Map.get(:member)
        |> Map.get(:id)
      assert(id == session_member.id)
  end

  test "can push new message", %{socket: socket, topic_1_name: topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, topic_1_name)
      body = "hey!!"
      ref = push socket, "new_message", %{"emotion" => "1", "body" => body}
      assert_reply ref, :ok
      assert_push "new_message", message
      assert(message.body == body)
  end

  test "can start message and unstart message", %{socket: socket, topic_1_name: topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, topic_1_name)
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

  test "can push delete message", %{socket: socket, topic_1_name: topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, topic_1_name)
      ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
      assert_reply ref, :ok
      assert_push "new_message", message

      ref2 = push socket, "delete_message", %{"id" => message.id}
      assert_reply ref2, :ok

      assert_push "delete_message", resp
      assert(resp == %{id: message.id, replyId: nil})
  end

  test "can thumbs up for message", %{socket: socket, topic_1_name: topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, topic_1_name)
      ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
      assert_reply ref, :ok
      assert_push "new_message", message

      ref2 = push socket, "thumbs_up", %{"id" => message.id}
      assert_reply ref2, :ok

      assert_push "update_message", resp
      assert(resp.has_voted)
  end

  test "can reply ", %{socket: socket, socket2: socket2, topic_1_name: topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, topic_1_name)
    {:ok, _, socket2} = subscribe_and_join(socket2, TopicChannel, topic_1_name)
    message_body = "hey!!"

    message_ref = push socket2, "new_message", %{"emotion" => "1", "body" => message_body}
    assert_reply message_ref, :ok
    assert_push "new_message", message
    assert(message.body == message_body)

    reply_body = "replyId body"
    reply_ref = push socket, "new_message", %{"emotion" => "1", "replyId" => message.id, "body" => reply_body}
    assert_reply reply_ref, :ok

    _message_id = message.id
    assert_broadcast "new_message", %{ replyId:  _message_id}
  end



  # test "when join send empty unread messages", %{socket: socket,topic_1_name: topic_1_name} do
  #   {:ok, _, _} = subscribe_and_join(socket, TopicChannel, topic_1_name)
  #
  #   first_resp_msg = %{"topics" =>  %{}, "summary" => %{"normal" => 0, "reply" => 0} }
  #   assert_push("unread_messages", push_resp_msg)
  #   assert(first_resp_msg == push_resp_msg)
  # end

end
