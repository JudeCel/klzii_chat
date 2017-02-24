defmodule KlziiChat.Services.Reports.ReportTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Report
  alias KlziiChat.Services.SessionReportingService
  describe "messages" do
    setup %{session_topic_1: session_topic, facilitator: facilitator} do
      payload_messages_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "messages", "scopes" => %{} }
      payload_messages_csv =  %{"sessionTopicId" => session_topic.id, "format" => "csv", "type" => "messages", "scopes" => %{} }
      payload_messages_txt =  %{"sessionTopicId" => session_topic.id, "format" => "txt", "type" => "messages", "scopes" => %{} }

      {:ok, pdf_report} = SessionReportingService.create_report(facilitator.id, payload_messages_pdf)
      {:ok, csv_report} = SessionReportingService.create_report(facilitator.id, payload_messages_csv)
      {:ok, txt_report} = SessionReportingService.create_report(facilitator.id, payload_messages_txt)

      {:ok, pdf_report: pdf_report, csv_report: csv_report, txt_report: txt_report}
    end

    test "pdf", %{pdf_report: pdf_report} do
      assert({:ok, report} = Report.run(pdf_report.id))
      assert(is_integer(report.resourceId))
      report = Repo.preload(report, [:resource])
      assert(report.resource.file)
    end

    test "csv", %{csv_report: csv_report} do
      assert({:ok, report} = Report.run(csv_report.id))
      assert(is_integer(report.resourceId))
      report = Repo.preload(report, [:resource])
      assert(report.resource.file)
    end

    test "txt", %{txt_report: txt_report} do
      assert({:ok, report} = Report.run(txt_report.id))
      assert(is_integer(report.resourceId))
      report = Repo.preload(report, [:resource])
      assert(report.resource.file)
    end
  end

  describe "statistic" do
    setup %{facilitator: facilitator} do
      payload_csv =  %{
          "sessionTopicId" => nil,
          "format" => "csv",
          "type" => "statistic", "scopes" => %{}
        }

      {:ok, csv_report} = SessionReportingService.create_report(facilitator.id, payload_csv)

      {:ok, csv_report: csv_report}
    end

    test "csv", %{csv_report: csv_report} do
      assert({:ok, report} = Report.run(csv_report.id))
      assert(is_integer(report.resourceId))
      report = Repo.preload(report, [:resource])
      assert(report.resource.file)
    end
  end

  describe "votes" do
    setup %{session_topic_1: session_topic, facilitator: facilitator} do
      payload_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "votes", "scopes" => %{} }
      payload_csv =  %{"sessionTopicId" => session_topic.id, "format" => "csv", "type" => "votes", "scopes" => %{} }
      payload_txt =  %{"sessionTopicId" => session_topic.id, "format" => "txt", "type" => "votes", "scopes" => %{} }


      {:ok, pdf_report} = SessionReportingService.create_report(facilitator.id, payload_pdf)
      {:ok, csv_report} = SessionReportingService.create_report(facilitator.id, payload_csv)
      {:ok, txt_report} = SessionReportingService.create_report(facilitator.id, payload_txt)

      {:ok, pdf_report: pdf_report, csv_report: csv_report, txt_report: txt_report}
    end

    test "pdf", %{pdf_report: pdf_report} do
      assert({:ok, report} = Report.run(pdf_report.id))
      assert(is_integer(report.resourceId))
      report = Repo.preload(report, [:resource])
      assert(report.resource.file)
    end

    test "csv", %{csv_report: csv_report} do
      assert({:ok, report} = Report.run(csv_report.id))
      assert(is_integer(report.resourceId))
      report = Repo.preload(report, [:resource])
      assert(report.resource.file)
    end
  end

  describe "whiteboards" do
    setup %{session_topic_1: session_topic, facilitator: facilitator} do
      payload_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "whiteboards", "scopes" => %{} }
      {:ok, pdf_report} = SessionReportingService.create_report(facilitator.id, payload_pdf)

      {:ok, pdf_report: pdf_report}
    end

    test "pdf", %{pdf_report: pdf_report} do
      assert({:ok, report} = Report.run(pdf_report.id))
      assert(is_integer(report.resourceId))
      report = Repo.preload(report, [:resource])
      assert(report.resource.file)
    end
  end
end
