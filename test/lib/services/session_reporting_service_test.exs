defmodule KlziiChat.Services.SessionReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionReportingService

  @report_prefix "ReportingService_test_report"

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 5,
      star: true,
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 3,
      star: false,
    ) |> Repo.insert!()

    {:ok, session: session, session_topic: session_topic_1, facilitator: facilitator}
  end

  test "Try to create incorrect report format and type" do
    assert({:error, "incorrect report format"} == SessionReportingService.create_session_topic_report(0, 1, 2, :incorrect, :all, true))
    assert({:error, "incorrect report type"} == SessionReportingService.create_session_topic_report(0, 1, 2, :pdf, :incorrect, true))
    assert({:error, "pdf is the only format that is acceptable for whiteboard report"} == SessionReportingService.create_session_topic_report(0, 1, 2, :txt, :whiteboard, true))
  end

  test "Get report name for a given type" do
    {:ok, "Session_topic_messages_report_1"} = SessionReportingService.get_report_name(:all, 1)
    {:ok, "Session_topic_messages_report_2"} = SessionReportingService.get_report_name(:star, 2)
    {:ok, "Session_topic_whiteboard_report_4"} = SessionReportingService.get_report_name(:whiteboard, 4)
  end


  test "Get all session topics reports", %{session: session, session_topic: session_topic,facilitator: facilitator} do
    session_id = session.id
    session_topic_id = session_topic.id

    SessionReportingService.create_session_topics_reports_record(session_id, session_topic_id, :whiteboard, true, :pdf)
    SessionReportingService.create_session_topics_reports_record(session_id, session_topic_id, :all, true, :pdf)
    SessionReportingService.create_session_topics_reports_record(session_id, session_topic_id, :star, true, :pdf)
    SessionReportingService.create_session_topics_reports_record(session_id, session_topic_id, :all, true, :txt)
    SessionReportingService.create_session_topics_reports_record(session_id, session_topic_id, :star, true, :txt)

    {:ok, reports} = SessionReportingService.get_session_topics_reports(session_id)


    %{^session_topic_id =>
      %{
        "pdf" => %{
          "whiteboard" => %{},
          "all" => %{},
          "star" => %{}
        },
        "txt" => %{
          "all" => %{},
          "star" => %{}
        }
      }
    } = reports
  end

  test "create report", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    #r = SessionReportingService.create_session_topic_report(session.id, facilitator.id, session_topic.id, :pdf, :all, :true)
    #:timer.sleep(500)
    #IO.inspect(r)
  end

  test "Delete session topics report", %{session: session, session_topic: session_topic,facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)

    #IO.inspect(SessionReportingService.get_session_topics_reports(session.id))

    SessionReportingService.delete_session_topic_report(report.id, facilitator.id)

    #IO.inspect(SessionReportingService.get_session_topics_reports(session.id))
  end
end
