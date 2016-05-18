defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{MessageService, ReportingService}

  setup %{session_topic_1: session_topic_1, member: member} do
    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member.id,
      body: "test message 1",
      emotion: 1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member.id,
      body: "test message 2",
      emotion: 2
    ) |> Repo.insert!()

    {:ok, session_topic_id: session_topic_1.id, member: member}
  end

  test "convert topic history to CSV", %{member: member, session_topic_id: session_topic_id} do
    {:ok, topic_history} = MessageService.history(session_topic_id, member)

    topic_hist_csv =
      ReportingService.topic_history_CSV_stream(topic_history)
      |> Enum.to_list()

    assert(length(topic_hist_csv) == 3)
    assert(List.first(topic_hist_csv) == "name,comment,date,is tagged,is reply,emotion\r\n")
  end

  test "convert message history to CSV string" do
    {:ok, ecto_datetime} = Ecto.DateTime.cast("2016-05-18T23:00:00Z")
    message = %{body: "some text", emotion: "normal", replyId: nil, session_member: %{username: "TestName"}, star: false, time: ecto_datetime}
    message_svn = "TestName,some text,2016-05-18 23:00:00,false,false,normal\r\n"

    assert(ReportingService.to_svn_string(message) == message_svn)
  end

  test "convert topic history to TXT", %{member: member, session_topic_id: session_topic_id} do
    {:ok, topic_history} = MessageService.history(session_topic_id, member)
    IO.inspect(topic_history)

    ReportingService.topic_history_TXT_stream(topic_history)
    |> Enum.to_list()
    |> IO.inspect
  end
end
