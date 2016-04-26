defmodule KlziiChat.SessionChannelTest do
  use KlziiChat.ChannelCase
  alias KlziiChat.SessionChannel
  alias KlziiChat.UserSocket
  alias KlziiChat.{Repo, SessionMember}
  use KlziiChat.SessionMemberCase

  setup %{session: session, session: session, member: member, member2: member2} do
    channal_name =  "sessions:" <> Integer.to_string(session.id)
    {:ok, socket} = connect(UserSocket, %{"token" => member.token})
    {:ok, socket2} = connect(UserSocket, %{"token" => member2.token})
    {:ok, socket: socket, socket2: socket2, channal_name: channal_name}
  end

  test "after join events", %{socket: socket, session: session, channal_name: channal_name} do
    {:ok, reply, socket} =
      join(socket, SessionChannel, channal_name)
    session_member = socket.assigns.session_member

    assert(reply.name == session.name)

    assert_push "self_info", _session_member

    assert_push "members", %{
      "facilitator" => _session_member,
      "observer" => [],
      "participant" => [member2]
    }

    Repo.get_by!(SessionMember, id: session_member.id).online |> assert
  end

  test "when join member broadcast others", %{socket: socket, socket2: socket2, channal_name: channal_name } do
    {:ok, _, socket} =
      join(socket, SessionChannel, channal_name)

    {:ok, _, socket2} =
      join(socket2, SessionChannel, channal_name)

    _session_member = socket.assigns.session_member
    _session_member2 = socket2.assigns.session_member

    assert_push "member_entered", _session_member2

    refute_push "member_entered", _session_member

  end


  test "when left channal broadcast others", %{socket: socket, socket2: socket2, channal_name: channal_name } do
    Process.flag(:trap_exit, true)
    {:ok, _, _} = join(socket, SessionChannel, channal_name)

    {:ok, _, socket2} = join(socket2, SessionChannel, channal_name)

    session_member2 = socket2.assigns.session_member

    ref = leave(socket2)
    assert_reply ref, :ok

    assert_push "member_left", session_member2

    Repo.get_by!(SessionMember, id: session_member2.id).online |> refute
  end

  test "when close channal broadcast others", %{socket: socket, socket2: socket2, channal_name: channal_name } do
    Process.flag(:trap_exit, true)
    {:ok, _, socket} = join(socket, SessionChannel, channal_name)
    session_member = socket.assigns.session_member

    {:ok, _, _} = join(socket2, SessionChannel, channal_name)

    :ok = close(socket)

    assert_push "member_left", session_member

    Repo.get_by!(SessionMember, id: session_member.id).online |> refute
  end

  test "when update session member broadcast others", %{socket: socket, socket2: socket2, channal_name: channal_name } do
    {:ok, _, socket} =
      join(socket, SessionChannel, channal_name)

    {:ok, _, socket2} =
      join(socket2, SessionChannel, channal_name)

    _session_member = socket.assigns.session_member
    _session_member2 = socket2.assigns.session_member

    push socket, "update_member", %{avatarData: %{ base: 2, face: 3, body: 1, desk: 2, head: 0 }}
    push socket, "update_member", %{avatarData: %{ base: 1, desk: 2}, username: "new cool name"}

    assert_push "update_member", session_member
    assert_push "update_member", session_member2
  end
end
