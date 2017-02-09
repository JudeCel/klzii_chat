defmodule KlziiChat.BackgroundTasks.Reports.SessionTopicReport do
  alias KlziiChat.Services.Reports.Report
  alias KlziiChat.Services.SessionReportingService
  alias KlziiChat.{Endpoint, Repo}

  def perform(report_id) do
    run_report(report_id)
  end

  def run_report(report_id) do
    try do
      case Report.run(report_id) do
        {:ok, report} ->
          notify(report.sessionId, report)
        {:error, reason} ->
          {:ok, report} = SessionReportingService.set_failed(reason, report_id)
          notify(report.sessionId, report)
          raise(reason)
      end
    rescue
      error ->
        {:ok, report} = SessionReportingService.set_failed(error, report_id)
        notify(report.sessionId, report)
        raise(error)
    end
  end

  def notify(session_Id, report) do
    Endpoint.broadcast!("sessions:#{session_Id}", "session_topics_report_updated", Repo.preload(report, :resource))
  end
end
