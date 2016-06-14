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
    Enum.reduce(reports, %{}, fn({session_topic_id, reports_by_format}, acc) ->
      Map.put(acc, to_string(session_topic_id),
        Enum.reduce(reports_by_format, %{}, fn({report_format, report_by_type}, acc2) ->
          Map.put(acc2, report_format,
            Enum.reduce(report_by_type, %{}, fn({type, report}, acc3) ->
              Map.put(acc3, type, render("show.json", %{report: report}))
            end)
          )
        end)
      )
    end)
  end
end
