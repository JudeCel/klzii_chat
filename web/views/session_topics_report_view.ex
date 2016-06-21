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

  @doc """
  Transforms ECTO query result (list of structs) into a nested maps for a JSON encoding.

  Returns: Map

  ## Examples

      ECTO Repo.all request result:

        Ecto.Schema.Metadata<:loaded, "SessionTopicsReports">,
          createdAt: #Ecto.DateTime<2016-06-20 18:26:08>, facilitator: true,
          format: "pdf", id: 422, message: nil, resource: nil, resourceId: nil,
          session: #Ecto.Association.NotLoaded<association :session is not loaded>,
          sessionId: 4740, sessionTopicId: 9479,
          session_topic: #Ecto.Association.NotLoaded<association :session_topic is not loaded>,
          status: "progress", type: "whiteboard",
          updatedAt: #Ecto.DateTime<2016-06-20 18:26:08>},
         %KlziiChat.SessionTopicReport{__meta__: #Ecto.Schema.Metadata<:loaded, "SessionTopicsReports">,
          createdAt: #Ecto.DateTime<2016-06-20 18:26:08>, facilitator: false,
          format: "pdf", id: 423, message: nil, resource: nil, resourceId: nil,
          session: #Ecto.Association.NotLoaded<association :session is not loaded>,
          sessionId: 4740, sessionTopicId: 9479,
          session_topic: #Ecto.Association.NotLoaded<association :session_topic is not loaded>,
          status: "progress", type: "all",
          updatedAt: #Ecto.DateTime<2016-06-20 18:26:08>}]

      Function output:

      %{
        "9267" => %{
          "pdf" => %{
            "all" => %{facilitator: false, format: "pdf", id: 410,
              message: nil, resource: nil, resourceId: nil, sessionId: 4634,
              sessionTopicId: 9267, status: "progress", type: "all"},
            "whiteboard" => %{facilitator: true, format: "pdf", id: 409, message: nil,
              resource: nil, resourceId: nil, sessionId: 4634, sessionTopicId: 9267,
              status: "progress", type: "whiteboard"}
          }
        }
      }
  """
  def render("reports.json", %{reports: reports}) do
    Enum.reduce(reports, Map.new, fn(report, acc) ->
      session_topic_id = to_string(report.sessionTopicId)
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
end
