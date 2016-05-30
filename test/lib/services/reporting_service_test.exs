defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{MessageService, ReportingService}
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.HTMLReportingHelper
  alias Ecto.DateTime

  @emoticons %{emoticons_qnt: 7, sprites_qnt: 6, emoticon_size: [55, 55]}

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

  test "topic history filters", %{topic_history: [th1, th2]} do
    csv_history_string = "#{th1.session_member.username},#{th1.body},#{DateTime.to_string(th1.time)}," <>
      "#{to_string(th1.star)},#{to_string(th1.replyId !== nil)},#{MessageDecorator.emotion_name(th1.emotion)}\r\n"
    txt_history_string = "#{th2.body}\r\n\r\n"

    assert(ReportingService.topic_hist_filter(:csv, th1) == csv_history_string)
    assert(ReportingService.topic_hist_filter(:txt, th2) == txt_history_string)
  end

  test "topic history headers", %{session: session, session_topic: session_topic} do
    assert(ReportingService.get_header(:txt, session.name, session_topic.name) ==
      "#{session.name} / #{session_topic.name}\r\n\r\n")
    assert(ReportingService.get_header(:csv, session.name, session_topic.name) ==
      "name,comment,date,is tagged,is reply,emotion\r\n")
    assert(ReportingService.get_header(:html, session.name, session_topic.name) ==
      "#{session.name} : #{session_topic.name}")
  end

  test "topic history stream - CSV", %{session: session, session_topic: session_topic, session_member: session_member, topic_history: [_, th2]} do
    csv_stream =
      ReportingService.get_stream(:csv, session, session_topic, session_member)
      |> Enum.to_list()

    assert(List.first(csv_stream) == ReportingService.get_header(:csv, session.name, session_topic.name))
    assert(List.last(csv_stream) == ReportingService.topic_hist_filter(:csv, th2))
  end

  test "topic history stream - TXT", %{session: session, session_topic: session_topic, session_member: session_member, topic_history: [_, th2]} do
    txt_stream =
      ReportingService.get_stream(:txt, session, session_topic, session_member)
      |> Enum.to_list()

    assert(List.first(txt_stream) == ReportingService.get_header(:txt, session.name, session_topic.name))
    assert(List.last(txt_stream) == ReportingService.topic_hist_filter(:txt, th2))
  end

  test "topic history - HTML", %{session: session, session_topic: session_topic, session_member: session_member, topic_history: topic_history} do
    html_text = ReportingService.get_html(session, session_topic, session_member)
    html_from_tempale = HTMLReportingHelper.html_from_template(%{
          header: ReportingService.get_header(:html, session.name, session_topic.name),
          topic_history: topic_history,
          emoticon: @emoticons
        })

    assert(html_text == html_from_tempale)
  end

  test "get full path to report file" do
    tmp_path = "/tmp/klzii_chat/reporting"
    report_name = "test_report"
    assert(ReportingService.get_full_report_path(tmp_path, report_name, :pdf) ==
      Path.join(tmp_path, report_name) <> "." <> to_string(:pdf))
    assert(ReportingService.get_full_report_path(tmp_path, report_name, "html") ==
      Path.join(tmp_path, report_name) <> ".html")
  end
end
