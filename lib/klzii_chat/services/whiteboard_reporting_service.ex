defmodule KlziiChat.Services.WhiteboardReportingService do
  alias KlziiChat.{Repo, ShapeView, SessionTopicView}
  alias KlziiChat.Services.FileService
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  alias KlziiChat.Queries.SessionTopic,  as: SessionTopicQueries

  @spec save_report(String.t, :pdf, integer) :: {:ok | :error, String.t}
  def save_report(report_name, :pdf, session_topic_id) do
    session_topic =
      SessionTopicQueries.find(session_topic_id)
      |> Repo.one

    shapes =
      QueriesShapes.base_query(session_topic)
      |> Repo.all
      |> Phoenix.View.render_many(ShapeView, "shape.json", as: :shape)

    session_topic_map =  Phoenix.View.render_one(session_topic, SessionTopicView, "show.json", as: :session_topic )

    header_title = "Whiteboard History - #{session_topic_map.session.account.name} / #{session_topic_map.session.name}"

    html_text = Phoenix.View.render_to_string(
      KlziiChat.Reporting.PreviewView, "shapes.html",
      shapes: shapes,
      brand_logo: session_topic_map.session.brand_logo,
      session_topic_name: session_topic_map.name,
      header_title: header_title,
      layout: {KlziiChat.LayoutView, "report.html"}
    )

    {:ok, html_file_path} = FileService.write_report(report_name, :pdf, html_text)
    {:ok, html_file_path}
  end
end
