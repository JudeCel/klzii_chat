defmodule KlziiChat.SessionTopicsReportView do
  use KlziiChat.Web, :view
  alias KlziiChat.ResourceView

  def render("show.json", %{report: report}) do
    %{
      id: report.id,
      facilitator: report.facilitator,
      format: report.format,
      message: report.message,
      sessionId: report.sessionId,
      sessionTopicId: report.sessionTopicId,
      status: report.status,
      type: report.type,
      resourceId: report.resourceId,
      resource: render_one(report.resource, ResourceView, "resource.json"),
    }
  end

  def render("reports.json", %{reports: reports}) do
    Enum.reduce(reports, %{}, fn(report, acc) ->
      session_topic_id = to_string(report.sessionTopicId)
      case Map.get(acc, session_topic_id) do
        nil -> Map.put(
          acc, session_topic_id, %{report.format => %{report.type => render("show.json", %{report: report})}}
        )
        reports_by_sessionTopicId ->
          case Map.get(reports_by_sessionTopicId, report.format) do
            nil -> put_in(acc[session_topic_id], %{report.format => %{report.type => render("show.json", %{report: report})}})
            report_by_format ->
              update_in(acc[session_topic_id][report.format], fn(val) ->
                Map.put(val, report.type, render("show.json", %{report: report}))
              end)
          end
      end
    end)
  end
end
