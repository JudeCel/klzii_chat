defmodule KlziiChat.Services.SessionReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.SessionTopicReport
  alias KlziiChat.Services.SessionReportingService

  @report_prefix "RSTReport"
  @db_wait 500

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

    on_exit fn ->
      KlziiChat.FileTestHelper.clean_up_uploads_dir
    end


    {:ok, session: session, session_topic: session_topic_1, facilitator: facilitator, participant: participant}
  end

  test "Get session member by id", %{facilitator: facilitator} do
    {:ok, member} = SessionReportingService.get_session_member(facilitator.id)
    assert(member.accountUserId == facilitator.accountUserId)
  end

  test "Error getting session member with incorrect id" do
    assert({:error, %{not_found: "No session member found with id: 123"}} == SessionReportingService.get_session_member("123"))
  end

  test "Report create permissions", %{facilitator: facilitator, participant: participant} do
    assert({:ok} == SessionReportingService.check_report_create_permision(facilitator))
    assert({:error, %{permissions: "Action not allowed!", code: 403}} == SessionReportingService.check_report_create_permision(participant))
  end

  test "Try to create incorrect report format and type" do
    assert({:error, %{format: "incorrect report format or type"}} = SessionReportingService.create_session_topic_report(0, 1, 2, :incorrect, :all, true))
    assert({:error, %{format: "incorrect report format or type"}} = SessionReportingService.create_session_topic_report(0, 1, 2, :pdf, :incorrect, true))
    assert({:error, %{format: "pdf is the only format that is available for whiteboard reports"}} = SessionReportingService.create_session_topic_report(0, 1, 2, :txt, :whiteboard, true))
  end

  test "Create session topics reports record", %{session: session, session_topic: session_topic,facilitator: facilitator} do
    {:ok, session_topics_report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, [get_session_topic_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
    assert(Repo.preload(session_topics_report, :resource) == get_session_topic_report)
  end

  test "Get report name for a given type" do
    {:ok, "STM_Report_1"} = SessionReportingService.get_report_name(:all, 1)
    {:ok, "STM_Report_2"} = SessionReportingService.get_report_name(:star, 2)
    {:ok, "STW_Report_4"} = SessionReportingService.get_report_name(:whiteboard, 4)
    {:ok, "STMS_Report_5"} = SessionReportingService.get_report_name(:votes, 5)
  end

  test "Save report of a given type", %{session_topic: session_topic} do
    {:ok, all_file_path} = SessionReportingService.save_report_async(:all, @report_prefix <> "all", :txt, session_topic.id, true)
    {:ok, star_file_path} = SessionReportingService.save_report_async(:star, @report_prefix <> "star", :csv, session_topic.id, false)
    {:ok, whiteboard_file_path} = SessionReportingService.save_report_async(:whiteboard, @report_prefix <> "wb", :pdf, session_topic.id, false)
    {:ok, votes_file_path} = SessionReportingService.save_report_async(:votes, @report_prefix <> "votes", :pdf, session_topic.id, true)

    assert(File.exists?(all_file_path))
    assert(File.exists?(star_file_path))
    assert(File.exists?(whiteboard_file_path))
    assert(File.exists?(votes_file_path))

    :ok = File.rm(all_file_path)
    :ok = File.rm(star_file_path)
    :ok = File.rm(whiteboard_file_path)
    :ok = File.rm(votes_file_path)
  end

  test "Upload report of a given type", %{session_topic: session_topic, facilitator: facilitator} do
    {:ok, report_path} = SessionReportingService.save_report_async(:all, @report_prefix <> "upload", :csv, session_topic.id, true)
    {:ok, resource} = SessionReportingService.upload_report_async(:csv, report_path, @report_prefix <> "upload", facilitator.accountUserId)

    assert(resource.type == "file")
    assert(resource.scope == "csv")
    assert(resource.file.file_name == @report_prefix <> "upload.csv")
    assert(resource.name == @report_prefix <> "upload")
    refute(File.exists?(report_path))
  end


  test "Update session topics reports record with completed status", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, session_topics_report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, report_path} = SessionReportingService.save_report_async(:all, @report_prefix <> "upload", :csv, session_topic.id, true)
    {:ok, resource} = SessionReportingService.upload_report_async(:csv, report_path, @report_prefix <> "upload", facilitator.accountUserId)

    {:ok, report} = SessionReportingService.update_session_topics_reports_record({:ok, resource}, session_topics_report.id)
    assert(report.status == "completed")
    assert(Repo.preload(report, :resource).resource == resource)
  end

  test "Update session topics reports record with failed status", %{session: session, session_topic: session_topic} do
    {:ok, session_topics_report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)

    {:ok, report} = SessionReportingService.update_session_topics_reports_record({:error, "some error message"}, session_topics_report.id)
    assert(report.status == "failed")
    assert(report.message == Poison.encode!("some error message"))
  end

  test "Create Report Async is updating session topics reports record with completed status", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    :ok = SessionReportingService.create_report_async(session.id, facilitator.accountUserId, report.id, session_topic.id, @report_prefix <> "createasync", :txt, :all, true)

    {:ok, [db_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
    assert(db_report.id == report.id)
    assert(db_report.status == "completed")
    refute(is_nil(db_report.resourceId))
  end

  test "Create Report Async is updating session topics reports record with failed status", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    :ok = SessionReportingService.create_report_async(session.id, facilitator, report.id, session_topic.id, @report_prefix <> "createasync", :incorrect_format, :all, true)

    {:ok, [db_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
    assert(db_report.id == report.id)
    assert(db_report.status == "failed")
    assert(db_report.message == Poison.encode!("Incorrect report format: incorrect_format"))
  end

  test "Create session topic report updating session topics reports record asynchronously", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topic_report(session.id, facilitator.id, session_topic.id, :csv, :all, :true)

    assert(report.status == "progress")
    assert(is_nil(report.resourceId))
    :timer.sleep(@db_wait)

    {:ok, [db_report]} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
    assert(db_report.id == report.id)
    assert(db_report.status == "completed")
    refute(is_nil(db_report.resourceId))
  end

  test "Error Creating session topic report with wrong permission", %{session: session, session_topic: session_topic, participant: participant} do
    assert({:error, %{permissions: "Action not allowed!", code: 403}} ==
     SessionReportingService.create_session_topic_report(session.id, participant.id, session_topic.id, :csv, :all, :true))
  end

  test "Get all session topics reports when deletedAt is not set", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    Repo.insert(%SessionTopicReport{
      sessionId: session.id,
      sessionTopicId: session_topic.id,
      type: "whiteboard",
      facilitator: true,
      format: "pdf",
      status: "progress"
    })

    Repo.insert(%SessionTopicReport{
      sessionId: session.id,
      sessionTopicId: session_topic.id,
      type: "all",
      facilitator: false,
      format: "csv",
      status: "completed"
    })

    Repo.insert(%SessionTopicReport{
      sessionId: session.id,
      sessionTopicId: session_topic.id,
      type: "all",
      facilitator: false,
      format: "txt",
      status: "failed"
    })


    {:ok, reports} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
    query = from(str in SessionTopicReport, where: str.sessionId == ^session.id, preload: [:resource])
    assert(reports == Repo.all(query))
  end

  test "Get session topic reports excluding one with deletedAt set", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    Repo.insert(%SessionTopicReport{
      sessionId: session.id,
      sessionTopicId: session_topic.id,
      type: "all",
      facilitator: false,
      format: "csv",
      status: "completed"
    })

    Repo.insert(%SessionTopicReport{
      sessionId: session.id,
      sessionTopicId: session_topic.id,
      type: "all",
      facilitator: false,
      format: "txt",
      status: "failed",
      deletedAt: Timex.now
    })

    assert({:ok, [%{status: "completed"}]} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id))
  end

  test "Error getting all session topics reports with incorrect permission", %{session: session, participant: participant} do
    assert({:error, %{permissions: "Action not allowed!", code: 403}} = SessionReportingService.get_session_topics_reports(session.id, participant.id))
  end

  test "Check report delete permision", %{facilitator: facilitator, participant: participant} do
    assert({:ok} == SessionReportingService.check_report_delete_permision(facilitator))
    assert({:error, %{permissions: "Action not allowed!", code: 403}} == SessionReportingService.check_report_delete_permision(participant))
  end

  test "Delete resource async - deletes resource if resource_id is not nil", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, _} = SessionReportingService.create_session_topic_report(session.id, facilitator.id, session_topic.id, :txt, :all, true)
    :timer.sleep(@db_wait)
    {:ok, [%{resourceId: resource_id}]} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
    SessionReportingService.delete_resource_async(facilitator.accountUserId, resource_id)
    :timer.sleep(@db_wait)
    {:ok, [%{resourceId: nil}]} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
  end

  test "Delete resource async - do nothing if resource_id is nil", %{facilitator: facilitator} do
    assert(is_nil(SessionReportingService.delete_resource_async(facilitator.accountUserId, nil)))
  end

  test "Delete report with completed status - report record is actually deleted", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, deleted_report} = SessionReportingService.delete_report(report)

    assert(report.id == deleted_report.id)
    assert({:ok, []} == SessionReportingService.get_session_topics_reports(session.id, facilitator.id))
  end

  test "Delete report with failed status - report record is NOT deleted, deletedAt field set", %{session: session, session_topic: session_topic}  do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, report} = SessionReportingService.update_session_topics_reports_record({:error, "some error message"}, report.id)
    {:ok, failed_report} = SessionReportingService.delete_report(report)

    query = from(str in SessionTopicReport, where: str.sessionId == ^session.id)
    [db_report] = Repo.all(query)

    assert(report.id == failed_report.id)
    assert(failed_report.id == db_report.id)
    assert(db_report.status == "failed")
    assert(db_report.message == Poison.encode!("some error message"))
    refute(is_nil(db_report.deletedAt))
  end

  test "Can't delete non-existent report", %{facilitator: facilitator} do
    SessionReportingService.check_delete_session_topic_report(nil, facilitator.accountUserId)
  end

  test "Can delete report with resource", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topic_report(session.id, facilitator.id, session_topic.id, :txt, :all, true)
    :timer.sleep(@db_wait)

    SessionReportingService.check_delete_session_topic_report(report, facilitator.accountUserId)
    :timer.sleep(@db_wait)

    assert({:ok, []} == SessionReportingService.get_session_topics_reports(session.id, facilitator.id))
  end

  test "Delete session topics report", %{session: session, session_topic: session_topic, facilitator: facilitator} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    {:ok, deleted_report} = SessionReportingService.delete_session_topic_report(report.id, facilitator.id)

    {:ok, []} = SessionReportingService.get_session_topics_reports(session.id, facilitator.id)
    assert(deleted_report.id == report.id)
  end

  test "Error deleting session topics report with incorrect permission", %{session: session, session_topic: session_topic, participant: participant} do
    {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
    assert({:error, %{permissions: "Action not allowed!", code: 403}} == SessionReportingService.delete_session_topic_report(report.id, participant.id))
  end

  test "Error deleting non-existend session topics report", %{facilitator: facilitator} do
    assert({:error, %{not_found: "Session Topic Report not found"}} == SessionReportingService.delete_session_topic_report(123, facilitator.id))
  end

   test "Recreate failed session topic report", %{session: session, session_topic: session_topic, facilitator: facilitator} do
     {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
     {:ok, report} = SessionReportingService.update_session_topics_reports_record({:error, "some error message"}, report.id)
     {:ok, new_report} = SessionReportingService.recreate_session_topic_report(report.id, facilitator.id)

     report_id = report.id
     new_report_id = new_report.id
     assert(report.status == "failed")
     assert(report.message == Poison.encode!("some error message"))
     assert(new_report.status == "progress")
     assert(new_report.message == nil)
     assert(new_report_id != report_id)
     :timer.sleep(@db_wait)

     query = from(str in SessionTopicReport, where: str.sessionId == ^session.id)
     [%{id: ^report_id, status: "failed", deletedAt: deleted_at}, %{id: ^new_report_id, status: "completed"}] = Repo.all(query)
     refute(is_nil(deleted_at))
  end

   test "Error recreating session topic report if no previous report record present", %{facilitator: facilitator} do
     assert({:error, %{not_found: "Session Topic Report not found"}} == SessionReportingService.recreate_session_topic_report(123, facilitator.id))
   end

   test "Error recreating session topic report with wrong permission", %{session: session, session_topic: session_topic, participant: participant} do
     {:ok, report} = SessionReportingService.create_session_topics_reports_record(session.id, session_topic.id, :all, true, :pdf)
     assert({:error, %{permissions: "Action not allowed!", code: 403}} == SessionReportingService.recreate_session_topic_report(report.id, participant.id))
   end
end
