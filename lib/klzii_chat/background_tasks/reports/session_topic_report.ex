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
          Endpoint.broadcast!("sessions:#{report.sessionId}", "session_topics_report_updated", Repo.preload(report, :resource))
        {:error, reason} ->
          {:ok, report} = SessionReportingService.set_failed(reason, report_id)
          Endpoint.broadcast!("sessions:#{report.sessionId}", "session_topics_report_updated", Repo.preload(report, :resource))
          raise(reason)
      end
    rescue
      e in RuntimeError ->
        {:ok, report} = SessionReportingService.set_failed(e, report_id)
        Endpoint.broadcast!("sessions:#{report.sessionId}", "session_topics_report_updated", Repo.preload(report, :resource))
        raise(e)
    end
  end
end
