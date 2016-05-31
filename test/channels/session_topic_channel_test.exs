defmodule KlziiChat.SessionTopicChannelTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, Presence, UserSocket, SessionTopicChannel}
  alias KlziiChat.Services.{SessionResourcesService}

  setup %{session_topic_1: session_topic_1, session: session, session: session, member: member, member2: member2} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    session_topic_1_name =  "session_topic:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(member)
    { :ok, jwt2, _encoded_claims } =  Guardian.encode_and_sign(member2)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket2} = connect(UserSocket, %{"token" => jwt2})

    {:ok, socket: socket, socket2: socket2, session_topic_1_name: session_topic_1_name}
  end

  test "receive console on subscribing", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, _} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    assert_push("console", %{})
  end

  test "set resource to console", %{account_user: account_user, socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, resource} = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert

    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    ref = push socket, "set_console_resource", %{"id" => resource.id}
    assert_reply ref, :ok
    assert_push("console", %{})
  end

  test "remove resource from console ", %{account_user: account_user, socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, resource} = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert

    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    ref = push socket, "remove_console_resource", %{"type" => resource.type}
    assert_reply ref, :ok
    assert_push("console", %{})
  end

  test "remove resource from console when resource enable", %{account_user: account_user, socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
    assert_push("console", %{})

    resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert!

    {:ok, session_resources} = SessionResourcesService.add_session_resources(resource.id, socket.assigns.session_member.id)
    session_resource = List.first(session_resources)

    ref = push socket, "set_console_resource", %{"id" => session_resource.resourceId}
    assert_reply ref, :ok

    {:ok, _} = SessionResourcesService.delete(socket.assigns.session_member.id, session_resource.id)

    assert_push("console", %{audio_id: nil, file_id: nil, image_id: nil, survey_id: nil, video_id: nil})
  end

  test "presents register is enable for topics", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} =
      join(socket, SessionTopicChannel, session_topic_1_name)
      session_member = socket.assigns.session_member

      id = Presence.list(socket)
        |> Map.get(session_member.id |> to_string)
        |> Map.get(:member)
        |> Map.get(:id)
      assert(id == session_member.id)
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

  test "can thumbs up for message", %{socket: socket, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionTopicChannel, session_topic_1_name)
      ref = push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
      assert_reply ref, :ok
      assert_push "new_message", message

      ref2 = push socket, "thumbs_up", %{"id" => message.id}
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
