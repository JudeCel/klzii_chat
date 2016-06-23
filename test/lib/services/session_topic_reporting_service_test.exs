defmodule KlziiChat.Services.SessionTopicReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService, FileService}
  alias KlziiChat.Helpers.HTMLSessionTopicReportHelper

  @emoticon_parameters %{emoticons_qnt: 7, sprites_qnt: 6, emoticon_size: [55, 55], selected_emoticon: 3}

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 0,
      star: true,
      createdAt: create_date1,
      updatedAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 1,
      star: false,
      createdAt: create_date2,
      updatedAt: create_date2
    ) |> Repo.insert!()

    messages = SessionTopicService.get_messages(session_topic_1.id, false, true)

    {:ok, messages: messages, session: session, session_topic: session_topic_1, facilitator: facilitator, create_date1: create_date1, create_date2: create_date2}
  end

  test "Get TXT stream", %{messages: messages, session: session, session_topic: session_topic} do
    txt_message_history =
      SessionTopicReportingService.get_stream(:txt, messages, session.name, session_topic.name)
      |> Enum.to_list()
    assert(Enum.count(txt_message_history) == 3)

    txt_header = List.first(txt_message_history)
    assert(String.contains?(txt_header, session.name) and String.contains?(txt_header, session_topic.name))

    txt_last = List.last(txt_message_history)
    message_last = List.last(messages)
    assert(String.contains?(txt_last, message_last.body))
  end

  test "Get CSV stream", %{messages: messages, session: session, session_topic: session_topic} do
    csv_message_history =
      SessionTopicReportingService.get_stream(:csv, messages, session.name, session_topic.name)
      |> Enum.to_list()
    assert(Enum.count(csv_message_history) == 3)

    csv_last = List.last(csv_message_history)
    csv_filterered_message = SessionTopicReportingService.message_csv_filter(List.last(messages))
    assert(csv_last == csv_filterered_message)
  end

  test "Get HTML from templates", %{messages: messages, session: session, session_topic: session_topic} do
    html_text =
      SessionTopicReportingService.get_html(messages, session.name, session_topic.name)

    html_from_template = HTMLSessionTopicReportHelper.html_from_template(%{
      header: "#{session.name} : #{session_topic.name}",
      messages: messages,
      emoticon_parameters: @emoticon_parameters
    })

    assert(html_text == html_from_template)
  end

  test "Get different report formats", %{messages: messages, session: session, session_topic: session_topic} do
    txt_message_stream =
      SessionTopicReportingService.get_stream(:txt, messages, session.name, session_topic.name)

    messages_star = SessionTopicService.get_messages(session_topic.id, true, true)
    csv_message_star_stream =
      SessionTopicReportingService.get_stream(:csv, messages_star, session.name, session_topic.name)

    messages_excl_fac = SessionTopicService.get_messages(session_topic.id, false, false)
    html_text_excl_fac =
      SessionTopicReportingService.get_html(messages_excl_fac, session.name, session_topic.name)

    assert({:ok, ^txt_message_stream} = SessionTopicReportingService.get_report(:txt, session_topic.id, false, true))
    assert({:ok, ^csv_message_star_stream} = SessionTopicReportingService.get_report(:csv, session_topic.id, true, true))
    assert({:ok, ^html_text_excl_fac} = SessionTopicReportingService.get_report(:pdf, session_topic.id, false, false))
  end

  test "Get error for incorrect report format", %{session_topic: session_topic} do
    assert({:error, "Incorrect report format: incorrect_format"}
      == SessionTopicReportingService.get_report(:incorrect_format, session_topic.id, false, true))
  end

  test "save csv report", %{session_topic: session_topic} do
    report_name = "SessionTopicReportingServiceTest_test_report"
    {:ok, report_file_path} = SessionTopicReportingService.save_report(report_name, :csv, session_topic.id, false, true)

    assert(report_file_path == FileService.get_tmp_path() <> "/#{report_name}.csv")
    assert(File.exists?(report_file_path))
    :ok = File.rm(report_file_path)
  end
end
