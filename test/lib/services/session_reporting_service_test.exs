defmodule KlziiChat.Services.SessionReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic_1} do
    {:ok, session_topic: session_topic_1}
  end

  describe "Report create permissions" do
    test "has permissions", %{facilitator: facilitator} do
      assert({:ok} == SessionReportingService.check_report_create_permision(facilitator))
    end

    test "has not permissions", %{participant: participant} do
      assert({:error, _ } = SessionReportingService.check_report_create_permision(participant))
    end
  end

  describe "Incorrect report payload" do
    test "file format", %{facilitator: facilitator} do
      payload =  %{"sessionTopicId" => 1, "format" => "incorrect", "type" => "messages" }
      assert({:error, %{format: "incorrect report format: incorrect"}} = SessionReportingService.create_report(facilitator.id, payload))
    end

    test "report type", %{facilitator: facilitator} do
      payload =  %{"sessionTopicId" => 1, "format" => "pdf", "type" => "incorrect" }
      assert({:error, %{type: "incorrect report type: incorrect"}} = SessionReportingService.create_report(facilitator.id, payload))
    end

    test "whiteboard messagesowed with pdf", %{facilitator: facilitator} do
      payload =  %{"sessionTopicId" => 1, "format" => "txt", "type" => "whiteboards"}
      assert({:error, %{format: "pdf is the only format that is available for whiteboard reports"}} = SessionReportingService.create_report(facilitator.id, payload))
    end
  end

  describe "Create report with include fields" do
    test "facilitator ", %{facilitator: facilitator, session_topic: session_topic} do
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "messages", "includeFields" => ["some name"] }
      assert({:ok, report} = SessionReportingService.create_report(facilitator.id, payload))
      assert(report.includeFields == get_in(payload, ["includeFields"]))
    end
  end

  describe "report with includes" do
    test "facilitator ", %{facilitator: facilitator, session_topic: session_topic} do
      payload =  %{
        "sessionTopicId" => session_topic.id,
        "format" => "pdf",
        "type" => "messages",
        "includes" => %{
          "defaultFields" => ["name"]
        }
      }
      assert({:ok, _} = SessionReportingService.create_report(facilitator.id, payload))
    end
  end

  describe "report with includes and include fields" do
    test "facilitator ", %{facilitator: facilitator, session_topic: session_topic} do
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "messages", "includes" => %{}, "includeFields" => ["some name"] }
      assert({:ok, _} = SessionReportingService.create_report(facilitator.id, payload))
    end
  end

  describe "report name" do
    test "messages", %{session: session} do
      payload = %{"type" => "messages"}
      assert {:ok, "Messages_Report_cool_session"} = SessionReportingService.get_report_name(payload, session)
    end

    test "star", %{session: session} do
      payload = %{"type" => "messages_stars_only"}
      assert {:ok, "Messages_Report_cool_session"} = SessionReportingService.get_report_name(payload, session)
    end

    test "whiteboard", %{session: session} do
      payload = %{"type" => "whiteboards"}
      assert {:ok, "Whiteboards_Report_cool_session"} = SessionReportingService.get_report_name(payload, session)
    end

    test "votes", %{session: session} do
      payload = %{"type" => "votes"}
      assert {:ok, "Votes_Report_cool_session"} = SessionReportingService.get_report_name(payload, session)
    end
  end

  describe "set status" do
    setup %{session_topic_1: session_topic, facilitator: facilitator, account_user_account_manager: account_user } do
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "messages", "includeFields" => ["some name"], "includes" => %{"facilitator" => false} }
      {:ok, report} = SessionReportingService.create_report(facilitator.id, payload)
      resource = Ecto.build_assoc(
       account_user.account, :resources,
       accountUserId: account_user.id,
       name: "test image 1",
       type: "image",
       scope: "collage"
     ) |> Repo.insert!
      {:ok, report: report, resource: resource}
    end

    test " complite status", %{report: report, resource: resource} do
      {:ok, update_report} = SessionReportingService.set_status({:ok, resource}, report.id)
      assert(update_report.status == "completed")
      assert(update_report.message == nil)
    end

    test " failed status", %{report: report} do
      {:ok, update_report} = SessionReportingService.set_status({:error, %{reason: "some error"}}, report.id)
      assert(update_report.status == "failed")
      assert(update_report.message == "{\"reason\":\"some error\"}")
    end
  end

  describe "recreate report" do
    setup %{session_topic_1: session_topic, facilitator: facilitator, account_user_account_manager: account_user} do
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "messages", "includes" => %{"facilitator" => true} }
      {:ok, report} = SessionReportingService.create_report(facilitator.id, payload)
      resource = Ecto.build_assoc(
        account_user.account, :resources,
        accountUserId: account_user.id,
        name: "test image 1",
        type: "image",
        scope: "collage"
      ) |> Repo.insert!
      {:ok, report: report, resource: resource}
    end

    test "when success", %{facilitator: facilitator, report: report, resource: resource} do
      {:ok, old_report} = SessionReportingService.set_status({:ok, resource}, report.id)
      {:ok, new_report} = SessionReportingService.recreate_report(report.id, facilitator.id)
      refute(new_report.id == old_report.id)
    end

    test "when failed", %{facilitator: facilitator, report: report} do
      {:ok, old_report} = SessionReportingService.set_status({:error, "some error"}, report.id)
      {:ok, new_report} = SessionReportingService.recreate_report(report.id, facilitator.id)
      refute(new_report.id == old_report.id)
    end
  end
end
