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
      emotion: 0,
      createdAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member2.id,
      body: "test message 2",
      emotion: 1,
      createdAt: create_date2
    ) |> Repo.insert!()

    {:ok, topic_history} = MessageService.history(session_topic_1.id, member)

    {:ok, session: session, session_topic: session_topic_1, session_member: member, topic_history: topic_history}
  end

  test "topic history filters", %{topic_history: topic_history} do
    assert(ReportingService.topic_hist_filter(:csv, List.first(topic_history)) ==
      "cool member,test message 1,2016-05-20 09:50:00,false,false,normal\r\n")
    assert(ReportingService.topic_hist_filter(:txt, List.last(topic_history)) ==
      "test message 2\r\n\r\n")
  end

  test "topic history headers", %{session: session, session_topic: session_topic} do
    assert(ReportingService.get_header(:txt, session.name, session_topic.name) ==
      "cool session / cool session topic 1\r\n\r\n")
    assert(ReportingService.get_header(:csv, session.name, session_topic.name) ==
      "name,comment,date,is tagged,is reply,emotion\r\n")
    assert(ReportingService.get_header(:html, session.name, session_topic.name) ==
      "cool session : cool session topic 1")
  end

  test "topic history stream - CSV", %{session: session, session_topic: session_topic, session_member: session_member} do
    csv_stream =
      ReportingService.get_stream(:csv, session, session_topic, session_member)
      |> Enum.to_list()

    assert(List.first(csv_stream) == ReportingService.get_header(:csv, session.name, session_topic.name))
    assert(List.last(csv_stream) == "cool member 2,test message 2,2016-05-20 09:55:00,false,false,smiling\r\n")
  end

  test "topic history stream - TXT", %{session: session, session_topic: session_topic, session_member: session_member} do
    txt_stream =
      ReportingService.get_stream(:txt, session, session_topic, session_member)
      |> Enum.to_list()

    assert(List.first(txt_stream) == ReportingService.get_header(:txt, session.name, session_topic.name))
    assert(List.last(txt_stream) == "test message 2\r\n\r\n")
  end

  test "topic history - HTML", %{session: session, session_topic: session_topic, session_member: session_member} do
    html_text = ReportingService.get_html(session, session_topic, session_member)

    assert(String.contains?(html_text, ReportingService.get_header(:html, session.name, session_topic.name)))
    assert(String.contains?(html_text, "cool member 2"))
    assert(String.contains?(html_text, "test message 2"))
    assert(String.contains?(html_text, "2016-05-20 09:55:00"))

    ReportingService.write_to_file("test", :pdf, session_member, session, session_topic)
    |> IO.inspect
  end
end
