defmodule KlziiChat.Services.SessionReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionReportingService

  @report_prefix "ReportingService_test_report"
  @date_time_format "{YYYY}_{0M}_{0D}_{h24}_{0m}"

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


  test "Get all session topics reports", %{session_topic: session_topic_1, facilitator: facilitator} do
    session_topic_id = session_topic_1.id

    SessionReportingService.create_session_topics_reports_record(session_topic_1.id, facilitator.id, :whiteboard, true, :pdf)
    SessionReportingService.create_session_topics_reports_record(session_topic_1.id, facilitator.id, :all, true, :pdf)
    SessionReportingService.create_session_topics_reports_record(session_topic_1.id, facilitator.id, :star, true, :pdf)
    SessionReportingService.create_session_topics_reports_record(session_topic_1.id, facilitator.id, :all, true, :txt)
    SessionReportingService.create_session_topics_reports_record(session_topic_1.id, facilitator.id, :star, true, :txt)

    reports = SessionReportingService.get_session_topics_reports(facilitator.id)


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
end
