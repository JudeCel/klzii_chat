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

  test "can join", %{socket: socket, channel_name: channel_name} do
    assert({:ok, _, _} = join(socket, SessionChannel, channel_name))
  end

  test "can update member", %{socket: socket, channel_name: channel_name} do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)
    push socket, "update_member", %{avatarData: %{base: 2, face: 3, body: 1, desk: 2, head: 0}}
  end

  test "can direct messages", %{socket2: socket2, socket: socket, channel_name: channel_name} do
    {:ok, _, socket2} = join(socket2, SessionChannel, channel_name)
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)
    reciever_member_id = socket.assigns.session_member.id

    ref1 = push socket2, "create_direct_message", %{ "recieverId" => reciever_member_id, "text" => "AAA" }
    assert_reply ref1, :ok, %{ message: %{} }
  end

  test "can read direct messages", %{ socket2: socket2, socket: socket, channel_name: channel_name } do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)
    {:ok, _, socket2} = join(socket2, SessionChannel, channel_name)
    sender_member_id = socket2.assigns.session_member.id
    reciever_member_id = socket.assigns.session_member.id

    ref1 = push socket2, "create_direct_message", %{ "recieverId" => reciever_member_id, "text" => "AAA" }
    assert_reply ref1, :ok

    ref2 = push socket, "set_read_direct_messages", %{ "senderId" => sender_member_id }
    assert_reply ref2, :ok, %{ count: %{} }
  end

  test "can get last messages", %{ socket2: socket2, socket: socket, channel_name: channel_name } do
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

  test "can create session topic report", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "pdf", "type" => "messages", "includes" => %{"facilitator"=> true} }

    ref = push(socket, "create_session_topic_report", payload)
    assert_reply(ref, :ok, %{})
  end

  test "can delete session topic report", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "txt", "type" => "messages" }
    {:ok, report} = SessionReportingService.create_report(socket.assigns.session_member.id, payload)

    del_ref = push(socket, "delete_session_topic_report", %{"id" => report.id})
    assert_reply(del_ref, :ok, _)
  end

  test "can recreate session topic report", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    {:ok, _, socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "txt", "type" => "messages" }

    {:ok, report} = SessionReportingService.create_report(socket.assigns.session_member.id, payload)

    ref = push(socket, "recreate_session_topic_report", %{"id" => report.id})
    assert_reply(ref, :ok, %{})
  end

  test "can get session topics reports", %{socket: socket, channel_name: channel_name, session_topic_1: session_topic_1} do
    {:ok, _, socket} = join(socket, SessionChannel, channel_name)

    payload =  %{"sessionTopicId" => session_topic_1.id, "format" => "txt", "type" => "messages" }
    {:ok, report} = SessionReportingService.create_report(socket.assigns.session_member.id, payload)

    ref = push(socket, "get_session_topics_reports", %{"id" => report.id})
    assert_reply(ref, :ok, %{})
  end

  test "can update session topics", %{socket: socket, channel_name: channel_name, session: session} do
    {:ok, _, _socket} = subscribe_and_join(socket, SessionChannel, channel_name)

    assert(:ok = KlziiChat.BackgroundTasks.SessionTopic.update_session_topics(session.id))
    assert_broadcast("update_session_topics", %{})
  end

end
