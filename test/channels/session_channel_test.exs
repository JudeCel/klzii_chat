defmodule KlziiChat.SessionChannelTest do
  use KlziiChat.ChannelCase
  alias KlziiChat.{Repo, UserSocket, SessionChannel, SessionTopicChannel}
  use KlziiChat.SessionMemberCase

  setup %{session_topic_1: session_topic_1, session: session, session: session, facilitator: facilitator, participant: participant} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    channel_name =  "sessions:" <> Integer.to_string(session.id)
    session_topic_1_name =  "session_topic:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    { :ok, jwt2, _encoded_claims } =  Guardian.encode_and_sign(participant)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket2} = connect(UserSocket, %{"token" => jwt2})
    {:ok, socket: socket, socket2: socket2, channel_name: channel_name, session_topic_1_name: session_topic_1_name}
  end

  test "when unauthorized", %{socket: socket, channel_name: channel_name} do
    {:error,  %{reason: "unauthorized"}} = join(socket, SessionChannel, channel_name <> "2233")
  end

  test "after join events", %{socket: socket, session: session, channel_name: channel_name} do
    {:ok, reply, socket} =
      join(socket, SessionChannel, channel_name)
    session_member = socket.assigns.session_member

    assert(reply.name == session.name)

    assert_push "self_info", self_info

    assert(self_info == session_member)

    assert_push "members", %{
      "facilitator" => facilitator,
      "observer" => [observer],
      "participant" => [participant, participant2]
    }

    assert_push "presence_state", state
    id = Map.get(state, session_member.id |> to_string)
      |> Map.get(:member)
      |> Map.get(:id)

    assert(id == session_member.id)
  end

  test "when join member broadcast others", %{socket: socket, socket2: socket2, channel_name: channel_name } do
    {:ok, _, socket} =
      join(socket, SessionChannel, channel_name)

    {:ok, _, _socket2} =
      join(socket2, SessionChannel, channel_name)

    session_member = socket.assigns.session_member

    assert_push "presence_diff", %{joins: joins}
    id = Map.get(joins,session_member.id |> to_string)
      |> Map.get(:member)
      |> Map.get(:id)
      assert(id == session_member.id)
  end

  test "when update session member broadcast others", %{socket: socket, socket2: socket2, channel_name: channel_name } do
    {:ok, _, socket} =
      join(socket, SessionChannel, channel_name)

    {:ok, _, socket2} =
      join(socket2, SessionChannel, channel_name)

    _session_member = socket.assigns.session_member
    _session_member2 = socket2.assigns.session_member

    push socket, "update_member", %{avatarData: %{ base: 2, face: 3, body: 1, desk: 2, head: 0 }}
    push socket, "update_member", %{avatarData: %{ base: 1, desk: 2}, username: "new cool name"}

    assert_push "self_info", session_member
    assert_push "self_info", session_member2

    assert_push "update_member", session_member
    assert_push "update_member", session_member2
  end

  #  Offline messages from others session_topics
  test "get unread messages notification when new message", %{socket2: socket2, socket: socket, channel_name: channel_name, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket2} = join(socket2, SessionTopicChannel, session_topic_1_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    ref1 = push socket2, "new_message", %{"emotion" => "1", "body" => "hey!!"}
    assert_reply ref1, :ok
    ref2 = push socket2, "new_message", %{"emotion" => "2", "body" => "hey hey!!"}
    assert_reply ref2, :ok

    session_member_id = "#{socket.assigns.session_member.id}"
    "session_topic:" <> id = session_topic_1_name

    assert_broadcast("unread_messages", %{^session_member_id => %{"session_topics" =>  %{^id => %{"normal" => 1} }, "summary" => %{"normal" => 1, "reply" => 0} }})
  end

  test "get unread messages notification when delete message", %{socket2: socket2, socket: socket, channel_name: channel_name, session_topic_1_name: session_topic_1_name} do
    {:ok, _, socket2} = join(socket2, SessionTopicChannel, session_topic_1_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    ref1 = push socket2, "new_message", %{"emotion" => "1", "body" => "hey!!"}
    assert_reply ref1, :ok
    assert_push "new_message", message
    ref2 = push socket2, "delete_message", %{"id" => message.id}
    assert_reply ref2, :ok
    session_member_id = "#{socket.assigns.session_member.id}"
    assert_broadcast("unread_messages", %{^session_member_id => %{"session_topics" =>  %{}, "summary" => %{"normal" => 0, "reply" => 0} }})
  end

end
