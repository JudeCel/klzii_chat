defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{MessageService, ReportingService, SessionMembersService}

  setup %{session: session, session_topic_1: session_topic_1, member: member, member2: member2} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member.id,
      body: "test message 1",
      emotion: 1,
      createdAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member2.id,
      body: "test message 2",
      emotion: 2,
      createdAt: create_date2
    ) |> Repo.insert!()

    {:ok, session: session, session_topic: session_topic_1, session_member: member}
  end

  test "convert topic history to CSV", %{session_member: session_member, session_topic: session_topic} do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    csv_header = "name,comment,date,is tagged,is reply,emotion\r\n"

    topic_hist_csv =
      ReportingService.topic_history_CSV_stream(csv_header, topic_history)
      |> Enum.to_list()

    assert(length(topic_hist_csv) == 3)
    assert(List.first(topic_hist_csv) == csv_header)
    assert(List.last(topic_hist_csv) == "cool member 2,test message 2,2016-05-20 09:55:00,false,false,2\r\n")
  end

  test "convert 1 message from history to CSV string" do
    {:ok, ecto_datetime} = Ecto.DateTime.cast("2016-05-18T23:00:00Z")
    message = %{body: "some text", emotion: "normal", replyId: nil, session_member: %{username: "TestName"}, star: false, time: ecto_datetime}
    message_svn = "TestName,some text,2016-05-18 23:00:00,false,false,normal\r\n"

    assert(ReportingService.to_svn_string(message) == message_svn)
  end

  test "convert topic history to TXT", %{session_member: session_member, session: session, session_topic: session_topic} do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    txt_header = "#{session.name} / #{session_topic.name}\r\n\r\n"  # "cool session / cool session topic 1"

    topic_hist_txt =
      ReportingService.topic_history_TXT_stream(txt_header, topic_history)
      |> Enum.to_list()

    assert(length(topic_hist_txt) == 3)
    assert(List.first(topic_hist_txt) == txt_header)
    assert(List.last(topic_hist_txt) == "test message 2\r\n\r\n")
  end

  test "convert topic history to HTML", %{session_member: session_member, session: session, session_topic: session_topic, member: member, member2: member2} do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)
    {:ok, session_members} = SessionMembersService.by_session(session.id)

    topic_hist_html = ReportingService.topic_history_HTML(System.cwd(), session.name, session_topic.name, topic_history, session_members)

    assert(String.contains?(topic_hist_html, "svg#{member.id}"))
    assert(String.contains?(topic_hist_html, "<td class=\"name #{member2.role}\">#{member2.username}</td>"))
    assert(String.contains?(topic_hist_html, Poison.encode!(session_members["participant"])))
  end

  test "report file", %{session_member: session_member, session: session, session_topic: session_topic, member: member, member2: member2} do
    ReportingService.save_file("report_test.pdf", :pdf, session_member, session, session_topic)
  end

end
