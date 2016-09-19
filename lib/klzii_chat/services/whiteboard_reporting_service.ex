defmodule KlziiChat.Services.WhiteboardReportingService do
  alias KlziiChat.{Repo, Shape,ShapeView}
  alias KlziiChat.Services.FileService
  alias KlziiChat.Queries.Shapes, as: QueriesShapes

  import Ecto.Query, only: [from: 2]

  @spec save_report(String.t, :pdf, integer) :: {:ok | :error, String.t}
  def save_report(report_name, :pdf, session_topic_id) do
    session_topic = Repo.get(SessionTopic, session_topic_id) |> Repo.preload([session: :account])
    wb_events = get_all_events(session_topic_id)

    shapes =
      QueriesShapes.base_query(session_topic)
      |> Repo.all
      |> Phoenix.View.render_many(ShapeView, "shape.json", as: :shape)

    header_title = "Whiteboard History - #{session_topic.session.account.name} / #{session_topic.session.name}"

    html_text = Phoenix.View.render_to_string(
      KlziiChat.Reporting.PreviewView, "shapes.html",
      shapes: shapes,
      session_topic_name: session_topic.name,
      header_title: header_title,
      layout: {KlziiChat.LayoutView, "report.html"}
    )

    {:ok, html_file_path} = FileService.write_report(report_name, :pdf, html_text)
    {:ok, html_file_path}
  end

  @spec get_all_events(integer) :: List.t
  def get_all_events(session_topic_id) do
    Repo.all(
      from shape in Shape,
      where: shape.sessionTopicId == ^session_topic_id,
      order_by: [asc: shape.updatedAt]
    )
  end
end
