defmodule KlziiChat.SessionChannelTest do
  use KlziiChat.ChannelCase
  alias KlziiChat.{Repo, UserSocket, SessionChannel}
  use KlziiChat.SessionMemberCase

  setup %{session: session, session: session, member: member, member2: member2} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    channel_name =  "sessions:" <> Integer.to_string(session.id)
    {:ok, socket} = connect(UserSocket, %{"token" => member.token})
    {:ok, socket2} = connect(UserSocket, %{"token" => member2.token})
    {:ok, socket: socket, socket2: socket2, channel_name: channel_name}
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


  test "when left channel broadcast others", %{socket: socket, socket2: socket2, channel_name: channel_name } do
    Process.flag(:trap_exit, true)
    {:ok, _, _} = join(socket, SessionChannel, channel_name)

    {:ok, _, socket2} = join(socket2, SessionChannel, channel_name)

    ref = leave(socket2)
    assert_reply ref, :ok
  end

  test "when close channel broadcast others", %{socket: socket, socket2: socket2, channel_name: channel_name } do
    Process.flag(:trap_exit, true)
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)

    {:ok, _, _} = join(socket2, SessionChannel, channel_name)

    :ok = close(socket)
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
  test "get unread messages notification", %{socket2: socket2, socket: socket, session_name: session_name, tipic_1_name: tipic_1_name, tipic_2_name: tipic_2_name} do
    {:ok, _, session_socket} = join(socket, SessionChannel, session_name)
    {:ok, _, topic_1_socket} = join(session_socket, TopicChannel, tipic_1_name)

    {:ok, _, socket2} = join(socket2, TopicChannel, tipic_2_name)
    {:ok, _, socket2} = subscribe_and_join(socket2, SessionChannel, session_name)

    session_member_id = get_session_member_id(socket2)
    id  = topic_id(tipic_1_name)

    ref1 = push topic_1_socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
    ref2 = push topic_1_socket, "new_message", %{"emotion" => "2", "body" => "hey hey!!"}

    assert_reply ref1, :ok
    assert_reply ref2, :ok

    resp_msg = %{session_member_id => %{"topics" =>  %{id => %{"normal" => 1} }, "summary" => %{"normal" => 1, "replay" => 0} }}
    assert_broadcast("unread_messages", broadcast_resp_msg)
    assert(resp_msg == broadcast_resp_msg)
  end

end
