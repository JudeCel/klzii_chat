defmodule KlziiChat.SessionTopicsReportView do
  use KlziiChat.Web, :view
  alias KlziiChat.ResourceView

  def render("show.json", %{report: report}) do
    %{
      id: report.id,
      includes: report.includes,
      format: report.format,
      message: get_message(report.message),
      sessionId: report.sessionId,
      sessionTopicId: get_session_topic_id(report),
      status: report.status,
      type: report.type,
      resourceId: report.resourceId,
      resource: render_one(report.resource, ResourceView, "resource.json"),
    }
  end
  def render("reports.json", %{reports: reports}) do
    Enum.reduce(reports, Map.new, fn(report, acc) ->
      session_topic_id = get_session_topic_id(report) |> to_string

      format = report.format
      type = report.type

      if Map.has_key?(acc, session_topic_id) do
        if Map.has_key?(acc[session_topic_id], format) do
          {_, acc} = get_and_update_in(acc[session_topic_id][format], &{&1, Map.put(&1, type, render("show.json", %{report: report}))})
          acc
        else
          {_, acc} = get_and_update_in(acc[session_topic_id], &{&1, Map.put(&1, format, %{type => render("show.json", %{report: report})})})
          acc
        end
      else
        Map.put(acc, session_topic_id, %{format => %{type => render("show.json", %{report: report})}})
      end
    end)
  end

  def get_message(nil), do: nil
  def get_message(message) do
    case Poison.decode(message) do
      {:ok, result} ->
        result
      {:error, _error} ->
        message
    end
  end

  def get_session_topic_id(report) do
    case report do
      %{type: "statistic"} ->
        "statistic"
      %{sessionTopicId: nil} ->
        "all"
      %{sessionTopicId: sessionTopicId} ->
        sessionTopicId
    end
  end
end
