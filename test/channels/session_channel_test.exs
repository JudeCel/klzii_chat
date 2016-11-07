defmodule KlziiChat.SessionChannelTest do
  use KlziiChat.{ChannelCase, SessionMemberCase}
  alias KlziiChat.{Repo, UserSocket, SessionChannel}
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic_1, session: session, session: session, facilitator: facilitator, participant: participant} do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    channel_name =  "sessions:" <> Integer.to_string(session.id)
    session_topic_1_name =  "session_topic:" <> Integer.to_string(session_topic_1.id)
    { :ok, jwt1, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    { :ok, jwt2, _encoded_claims } =  Guardian.encode_and_sign(participant)

    {:ok, socket} = connect(UserSocket, %{"token" => jwt1})
    {:ok, socket2} = connect(UserSocket, %{"token" => jwt2})
    {:ok, socket: socket, socket2: socket2, channel_name: channel_name, session_topic_1_name: session_topic_1_name, session_topic_1: session_topic_1, session: session}
  end

  test "when unauthorized", %{socket: socket, channel_name: channel_name} do
    {:error, "You don't have access this session"} = join(socket, SessionChannel, channel_name <> "2233")
  end

  test "after join events", %{socket: socket, session: session, channel_name: channel_name} do
    {:ok, reply, socket} =
      join(socket, SessionChannel, channel_name)
    session_member = socket.assigns.session_member

    assert(reply.name == session.name)

    assert_push "self_info", self_info

    assert(self_info == session_member)

    assert_push "members", %{
      "facilitator" => %{},
      "observer" => [%{}],
      "participant" => [%{}, %{}]
    }

    assert_push "presence_state", %{}
  end

  test "when update session member broadcast others", %{socket: socket, socket2: socket2, channel_name: channel_name} do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)

    {:ok, _, _socket2} = join(socket2, SessionChannel, channel_name)

    push socket, "update_member", %{avatarData: %{base: 2, face: 3, body: 1, desk: 2, head: 0}}
    push socket, "update_member", %{avatarData: %{base: 1, desk: 2}, username: "new cool name"}

    assert_push "self_info", %{}

    _session_member_id = socket.assigns.session_member.id

    assert_push "update_member", %{id: _session_member_id}
  end

  test "create direct message", %{socket2: socket2, socket: socket, channel_name: channel_name} do
    {:ok, _, socket2} = join(socket2, SessionChannel, channel_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)
    reciever_member_id = socket.assigns.session_member.id

    ref1 = push socket2, "create_direct_message", %{ "recieverId" => reciever_member_id, "text" => "AAA" }
    assert_reply ref1, :ok, %{ message: %{} }

    member_id = to_string(reciever_member_id)
    assert_broadcast("new_direct_message", %{ ^member_id => %{} })
  end

  test "set all messages read", %{ socket2: socket2, socket: socket, channel_name: channel_name } do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)
    {:ok, _, socket2} = join(socket2, SessionChannel, channel_name)
    sender_member_id = socket2.assigns.session_member.id
    reciever_member_id = socket.assigns.session_member.id

    ref1 = push socket2, "create_direct_message", %{ "recieverId" => reciever_member_id, "text" => "AAA" }
    assert_reply ref1, :ok

    ref2 = push socket, "set_read_direct_messages", %{ "senderId" => sender_member_id }
    assert_reply ref2, :ok, %{ count: %{} }
  end

  test "get last messages for each user", %{ socket2: socket2, socket: socket, channel_name: channel_name } do
    sender_member_id = socket.assigns.session_member.id

    {:ok, _, socket2} = join(socket2, SessionChannel, channel_name)

    ref1 = push socket2, "get_last_messages", %{ "senderId" => sender_member_id }
    assert_reply ref1, :ok, %{ messages: %{} }
  end

  test "get all direct messages", %{ socket2: socket2, socket: socket, channel_name: channel_name } do
    {:ok, _, socket2} = join(socket2, SessionChannel, channel_name)
    reciever_member_id = socket.assigns.session_member.id
    push_data = %{ "recieverId" => reciever_member_id, "page" => 0 }

    push(socket2, "get_all_direct_messages", push_data)
    |> assert_reply(:ok, %{ messages: %{ read: _, unread: _, currentPage: _ } })
  end

  test "create session topic report", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    session_topic_1_id = session_topic_1.id
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "pdf", "type" => "messages", "includes" => %{"facilitator"=> true} }

    ref = push(socket, "create_session_topic_report", payload)
    assert_reply(ref, :ok, %{sessionTopicId: ^session_topic_1_id, status: "progress"})
  end

  test "delete session topic report", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "txt", "type" => "messages" }
    {:ok, report} = SessionReportingService.create_report(socket.assigns.session_member.id, payload)

    del_ref = push(socket, "delete_session_topic_report", %{"id" => report.id})
    assert_reply(del_ref, :ok, _)
  end

  test "recreate session topic report", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "txt", "type" => "messages" }

    {:ok, report} = SessionReportingService.create_report(socket.assigns.session_member.id, payload)

    ref = push(socket, "recreate_session_topic_report", %{"id" => report.id})
    assert_reply(ref, :ok, %{status: "progress"})
  end

  test "get session topics reports", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "txt", "type" => "messages" }
    {:ok, report} = SessionReportingService.create_report(socket.assigns.session_member.id, payload)

    ref = push(socket, "get_session_topics_reports", %{"id" => report.id})
    session_topic_1_id = to_string(session_topic_1.id)

    assert_reply(ref, :ok, %{^session_topic_1_id => %{"txt" => %{"messages" => %{status: "progress"}}}})
  end

  test "update session topics", %{socket: socket, channel_name: channel_name, session: session} do
    {:ok, _, _socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    assert(:ok = KlziiChat.BackgroundTasks.SessionTopic.update_session_topics(session.id))
    assert_broadcast("update_session_topics", %{session_topics: _})
  end

end
