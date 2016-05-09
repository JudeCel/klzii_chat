defmodule KlziiChat.SessionChannelTest do
  use KlziiChat.ChannelCase
  alias KlziiChat.{Repo, UserSocket, SessionChannel, TopicChannel}
  use KlziiChat.SessionMemberCase

  setup %{topic_1: topic_1, session: session, session: session, member: member, member2: member2} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    channel_name =  "sessions:" <> Integer.to_string(session.id)
    topic_1_name =  "topics:" <> Integer.to_string(topic_1.id)

    {:ok, socket} = connect(UserSocket, %{"token" => member.token})
    {:ok, socket2} = connect(UserSocket, %{"token" => member2.token})
    {:ok, socket: socket, socket2: socket2, channel_name: channel_name, topic_1_name: topic_1_name}
  end

  test "after join events", %{socket: socket, session: session, channel_name: channel_name} do
    {:ok, reply, socket} =
      join(socket, SessionChannel, channel_name)
    session_member = socket.assigns.session_member

    assert(reply.name == session.name)

    assert_push "self_info", _session_member
    assert_push "members", %{
      "facilitator" => _session_member,
      "observer" => [],
      "participant" => [member2]
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

    assert_push "update_member", session_member
    assert_push "update_member", session_member2
  end

  #  Offline messages from others topics
  test "get unread messages notification when new message", %{socket2: socket2, socket: socket, channel_name: channel_name, topic_1_name: topic_1_name} do
    {:ok, _, socket2} = join(socket2, TopicChannel, topic_1_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    ref1 = push socket2, "new_message", %{"emotion" => "1", "body" => "hey!!"}
    assert_reply ref1, :ok
    ref2 = push socket2, "new_message", %{"emotion" => "2", "body" => "hey hey!!"}
    assert_reply ref2, :ok

    session_member_id = "#{socket.assigns.session_member.id}"
    "topics:" <> id = topic_1_name

    assert_broadcast("unread_messages", %{^session_member_id => %{"topics" =>  %{^id => %{"normal" => 1} }, "summary" => %{"normal" => 1, "reply" => 0} }})
  end

  test "get unread messages notification when delete message", %{socket2: socket2, socket: socket, channel_name: channel_name, topic_1_name: topic_1_name} do
    {:ok, _, socket2} = join(socket2, TopicChannel, topic_1_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    ref1 = push socket2, "new_message", %{"emotion" => "1", "body" => "hey!!"}
    assert_reply ref1, :ok
    assert_push "new_message", message
    ref2 = push socket2, "delete_message", %{"id" => message.id}
    assert_reply ref2, :ok
    session_member_id = "#{socket.assigns.session_member.id}"
    assert_broadcast("unread_messages", %{^session_member_id => %{"topics" =>  %{}, "summary" => %{"normal" => 0, "reply" => 0} }})
  end

end
