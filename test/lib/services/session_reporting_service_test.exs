defmodule KlziiChat.Services.SessionReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.SessionTopicReport
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

    {:ok, session: session, session_topic: session_topic_1, facilitator: facilitator, participant: participant}
  end

  test "Report create permissions", %{facilitator: facilitator, participant: participant} do
    assert(:ok == SessionReportingService.check_report_create_permision(facilitator))
    assert({:error, "Action not allowed!"} == SessionReportingService.check_report_create_permision(participant))
  end

  test "Try to create incorrect report format and type" do
    assert({:error, "incorrect report format"} == SessionReportingService.create_session_topic_report(0, 1, 2, :incorrect, :all, true))
    assert({:error, "incorrect report type"} == SessionReportingService.create_session_topic_report(0, 1, 2, :pdf, :incorrect, true))
    assert({:error, "pdf is the only format that is available for whiteboard report"} == SessionReportingService.create_session_topic_report(0, 1, 2, :txt, :whiteboard, true))
  end

  test "Create session topics reports record", %{session: session, session_topic: session_topic,facilitator: facilitator} do
    {:ok, session_topics_report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, [get_session_topic_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator)
    assert(Repo.preload(session_topics_report, :resource) == get_session_topic_report)
  end

  test "Get report name for a given type" do
    {:ok, "Session_topic_messages_report_1"} = SessionReportingService.get_report_name(:all, 1)
    {:ok, "Session_topic_messages_report_2"} = SessionReportingService.get_report_name(:star, 2)
    {:ok, "Session_topic_whiteboard_report_4"} = SessionReportingService.get_report_name(:whiteboard, 4)
  end

  test "Save report of a given type", %{session_topic: session_topic} do
    {:ok, all_file_path} = SessionReportingService.save_report_async(:all, @report_prefix <> "all", :txt, session_topic.id, false)
    {:ok, star_file_path} = SessionReportingService.save_report_async(:star, @report_prefix <> "star", :csv, session_topic.id, true)
    {:ok, whiteboard_file_path} = SessionReportingService.save_report_async(:whiteboard, @report_prefix <> "wb", :pdf, session_topic.id, true)

    assert(File.exists?(all_file_path))
    assert(File.exists?(star_file_path))
    assert(File.exists?(whiteboard_file_path))

    File.rm(all_file_path)
    File.rm(star_file_path)
    File.rm(whiteboard_file_path)
  end

  test "Upload report of a given type", %{session_topic: session_topic, facilitator: facilitator} do
    {:ok, report_path} = SessionReportingService.save_report_async(:all, @report_prefix <> "upload", :csv, session_topic.id, true)
    {:ok, resource} = SessionReportingService.upload_report_async(:csv, report_path, @report_prefix <> "upload", facilitator)

    assert(resource.type == "file")
    assert(resource.scope == "csv")
    assert(resource.file.file_name == @report_prefix <> "upload.csv")
    assert(resource.name == @report_prefix <> "upload")
    refute(File.exists?(report_path))
  end


  test "Update session topics reports record with completed status", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, session_topics_report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, report_path} = SessionReportingService.save_report_async(:all, @report_prefix <> "upload", :csv, session_topic.id, true)
    {:ok, resource} = SessionReportingService.upload_report_async(:csv, report_path, @report_prefix <> "upload", facilitator)

    {:ok, report} = SessionReportingService.update_session_topics_reports_record({:ok, resource}, session_topics_report.id)
    assert(report.status == "completed")
    assert(Repo.preload(report, :resource).resource == resource)
  end

  test "Update session topics reports record with failed status", %{session: session, session_topic: session_topic} do
    {:ok, session_topics_report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)

    {:ok, report} = SessionReportingService.update_session_topics_reports_record({:error, "some error message"}, session_topics_report.id)
    assert(report.status == "failed")
    assert(report.message == "some error message")
  end

  test "Create Report Async is updating session topics reports record", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    :ok = SessionReportingService.create_report_async(session.id, facilitator, report.id, session_topic.id, @report_prefix <> "createasync", :txt, :all, true)

    {:ok, [db_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator)
    assert(db_report.id == report.id)
    assert(db_report.status == "completed")
    assert(db_report.resourceId != nil)
  end

  test "Create session topic report updating session topics reports record asynchronously", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topic_report(session.id, facilitator, session_topic.id, :csv, :all, :true)

    assert(report.status == "progress")
    assert(report.resourceId == nil)
    :timer.sleep(500)

    {:ok, [db_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator)
    assert(db_report.id == report.id)
    assert(db_report.status == "completed")
    assert(db_report.resourceId != nil)
  end

  test "Get all session topics reports", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    Repo.insert(%SessionTopicReport{
      sessionId: session.id,
      sessionTopicId: session_topic.id,
      type: "whiteboard",
      facilitator: true,
      format: "pdf"
    })

    Repo.insert(%SessionTopicReport{
      sessionId: session.id,
      sessionTopicId: session_topic.id,
      type: "all",
      facilitator: false,
      format: "csv"
    })

    {:ok, reports} = SessionReportingService.get_session_topics_reports(session.id, facilitator)
    query = from(str in SessionTopicReport, where: str.sessionId == ^session.id, preload: [:resource])
    assert(reports == Repo.all(query))
  end

  test "Error getting all session topics reports with incorrect permission", %{session: session, participant: participant} do
    assert({:error, "Action not allowed!"} = SessionReportingService.get_session_topics_reports(session.id, participant))
  end

  test "Delete session topics report", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, deleted_report} = SessionReportingService.delete_session_topic_report(report.id, facilitator)

    {:ok, []} = SessionReportingService.get_session_topics_reports(session.id, facilitator)
    assert(deleted_report.id == report.id)
  end

  test "Error deleting session topics report with incorrect permission", %{session: session, session_topic: session_topic, participant: participant} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    assert({:error, "Action not allowed!"} == SessionReportingService.delete_session_topic_report(report.id, participant))
  end

  test "Error deleting non-existend session topics report", %{facilitator: facilitator} do
    assert({:error, "Session Topic Report not found"} == SessionReportingService.delete_session_topic_report(123, facilitator))
  end

  test "Recreate session topic  report", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, report} = SessionReportingService.update_session_topics_reports_record({:error, "some error message"}, report.id)
    {:ok, new_report} = SessionReportingService.recreate_session_topic_report(report.id, facilitator)

    assert(report.status == "failed")
    assert(report.message == "some error message")
    assert(new_report.status == "progress")
    assert(new_report.message == nil)
    assert(new_report.id == report.id)
    :timer.sleep(500)

    {:ok, [db_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator)
    assert(db_report.id == new_report.id)
    assert(db_report.status == "completed")
    assert(db_report.resourceId != nil)
  end

end
