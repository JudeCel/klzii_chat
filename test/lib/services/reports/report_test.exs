defmodule KlziiChat.Services.Reports.ReportTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Report
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator} do
    payload_pdf =  %{"sessionTopicId" => session_topic.id, "format" => "pdf", "type" => "whiteboards", "scopes" => %{} }
    payload_csv =  %{"sessionTopicId" => session_topic.id, "format" => "csv", "type" => "messages", "scopes" => %{} }
    payload_text =  %{"sessionTopicId" => session_topic.id, "format" => "txt", "type" => "votes", "scopes" => %{} }

    {:ok, pdf_report} = SessionReportingService.create_report(facilitator.id, payload_pdf)
    {:ok, csv_report} = SessionReportingService.create_report(facilitator.id, payload_csv)
    {:ok, txt_report} = SessionReportingService.create_report(facilitator.id, payload_text)

    {:ok, pdf_report: pdf_report, csv_report: csv_report, txt_report: txt_report}
  end

  describe "run " do
    test "success", %{pdf_report: pdf_report, csv_report: csv_report, txt_report: txt_report} do
      assert({:ok, _} = Report.run(pdf_report.id))
      assert({:ok, _} = Report.run(csv_report.id))
      assert({:ok, _} = Report.run(txt_report.id))
    end
  end

end
