defmodule KlziiChat.Services.SessionReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.SessionTopicReport
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
      payload =  %{"sessionTopicId" => 1, "format" => "incorrect", "type" => "all" }
      assert({:error, %{format: "incorrect report format"}} = SessionReportingService.create_report(facilitator.id, payload))
    end

    test "report type", %{facilitator: facilitator} do
      payload =  %{"sessionTopicId" => 1, "format" => "pdf", "type" => "incorrect" }
      assert({:error, %{type: "incorrect report type"}} = SessionReportingService.create_report(facilitator.id, payload))
    end

    test "whiteboard allowed with pdf", %{facilitator: facilitator} do
      payload =  %{"sessionTopicId" => 1, "format" => "txt", "type" => "whiteboard"}
      assert({:error, %{format: "pdf is the only format that is available for whiteboard reports"}} = SessionReportingService.create_report(facilitator.id, payload))
    end
  end

  describe "Create report with scopes" do
    test "facilitator ", %{facilitator: facilitator, session_topic: session_topic} do
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "all", "scopes" => %{} }
      {:ok, report} = SessionReportingService.create_report(facilitator.id, payload)
    end
  end

  describe "report with includes" do
    test "facilitator ", %{facilitator: facilitator, session_topic: session_topic} do
      payload =  %{
        "sessionTopicId" => session_topic.id,
        "format" => "pdf",
        "type" => "all",
        "scopes" => %{},
        "includes" => %{
          "defaultFields" => ["name"]
        }
      }
      {:ok, report} = SessionReportingService.create_report(facilitator.id, payload)
    end
  end

  describe "report with includes and scopes" do
    test "facilitator ", %{facilitator: facilitator, session_topic: session_topic} do
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "all", "includes" => %{"defaultFields" => [] } }
      {:ok, report} = SessionReportingService.create_report(facilitator.id, payload)
    end
  end

  describe "report name" do
    test "all" do
      {:ok, "STM_Report_1"} = SessionReportingService.get_report_name("all", 1)
    end

    test "star" do
      {:ok, "STM_Report_2"} = SessionReportingService.get_report_name("star", 2)
    end

    test "whiteboard" do
      {:ok, "STW_Report_4"} = SessionReportingService.get_report_name("whiteboard", 4)
    end

    test "votes" do
      {:ok, "STMS_Report_5"} = SessionReportingService.get_report_name("votes", 5)
    end
  end

  describe "set status" do
    setup %{session_topic_1: session_topic, facilitator: facilitator, account_user_account_manager: account_user } do
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "all", "includes" => %{"defaultFields" => []} }
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
      payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "all", "includes" => %{"defaultFields" => []} }
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

    test "failed success", %{facilitator: facilitator, report: report, resource: resource} do
      {:ok, old_report} = SessionReportingService.set_status({:error, "some error"}, report.id)
      {:ok, new_report} = SessionReportingService.recreate_report(report.id, facilitator.id)
      refute(new_report.id == old_report.id)
    end
  end
end
