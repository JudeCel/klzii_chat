defmodule KlziiChat.TopicChannelTest do
  use KlziiChat.ChannelCase
  use KlziiChat.SessionMemberCase
  alias KlziiChat.{Repo, Presence, UserSocket, SessionChannel, TopicChannel}

  setup %{topic_1: topic_1, topic_2: topic_2, session: session, session: session, member: member, member2: member2} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    session_name =  "sessions:" <> Integer.to_string(session.id)
    tipic_1_name =  "topics:" <> Integer.to_string(topic_1.id)
    tipic_2_name =  "topics:" <> Integer.to_string(topic_2.id)
    {:ok, socket} = connect(UserSocket, %{"token" => member.token})
    {:ok, socket2} = connect(UserSocket, %{"token" => member2.token})
    {:ok, socket: socket, socket2: socket2, session_name: session_name, tipic_1_name: tipic_1_name, tipic_2_name: tipic_2_name}
  end

  def topic_id(channel) do
    case channel do
      "topics:" <>  id ->
        id
      "sessions:" <>  id ->
        id
    end
  end

  def get_session_member_id(socket) do
    socket.assigns.session_member.id |> to_string
  end

  test "presents register is enable for topics", %{socket: socket, tipic_1_name: tipic_1_name} do
    {:ok, _, socket} =
      join(socket, TopicChannel, tipic_1_name)
      session_member = socket.assigns.session_member

      id = Presence.list(socket)
        |> Map.get(session_member.id |> to_string)
        |> Map.get(:member)
        |> Map.get(:id)
      assert(id == session_member.id)
  end

  test "can push new message", %{socket: socket, tipic_1_name: tipic_1_name} do
    {:ok, _, socket} = subscribe_and_join(socket, TopicChannel, tipic_1_name)
      push socket, "new_message", %{"emotion" => "1", "body" => "hey!!"}
      assert_broadcast "new_message", %KlziiChat.Message{}
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

  test "when join send empty unread messages", %{socket: socket, session_name: session_name, tipic_1_name: tipic_1_name} do
    {:ok, _, socket} = join(socket, SessionChannel, session_name)
    {:ok, _, _} = subscribe_and_join(socket, TopicChannel, tipic_1_name)

    first_resp_msg = %{"topics" =>  %{}, "summary" => %{"normal" => 0, "replay" => 0} }
    assert_push("unread_messages", push_resp_msg)
    assert(first_resp_msg == push_resp_msg)
  end

end
