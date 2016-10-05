defmodule KlziiChat.Reporting.PreviewController do
  alias KlziiChat.{Repo, SessionTopic, ShapeView, MiniSurveyView, SessionTopicView}
  alias KlziiChat.Queries.Messages, as: QueriesMessages
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  alias KlziiChat.Queries.SessionTopic,  as: SessionTopicQueries
  use KlziiChat.Web, :controller
  plug :filter_access

  def messages(conn, %{"session_topic_id" => session_topic_id}) do
    session_topic =
      SessionTopicQueries.find(session_topic_id)
      |> Repo.one |> Phoenix.View.render_one(SessionTopicView, "show.json", as: :session_topic )

    messages =
      QueriesMessages.session_topic_messages(session_topic_id, [star: false, facilitator: true])
      |> Repo.all

      header_title = "Chat History - #{session_topic.session.account.name} / #{session_topic.session.name}"

      conn |>
      put_layout("report.html") |>
      render("messages.html", %{
        session_topic_name: session_topic.name,
        brand_logo: session_topic.session.brand_logo.url.full,
        time_zone: session_topic.session.timeZone,
        header_title: header_title, messages: messages
      })
  end

  def whiteboard(conn, %{"session_topic_id" => session_topic_id}) do
    session_topic =
      SessionTopicQueries.find(session_topic_id)
      |> Repo.one

    shapes =
      QueriesShapes.base_query(session_topic)
      |> Repo.all
      |> Phoenix.View.render_many(ShapeView, "shape.json", as: :shape)

      session_topic_map = Phoenix.View.render_one(session_topic, SessionTopicView, "show.json", as: :session_topic )
      header_title = "Whiteboard History - #{session_topic_map.session.account.name} / #{session_topic_map.session.name}"


      conn |>
      put_layout("report.html") |>
      render("shapes.html", %{
        header_title: header_title,
        session_topic_map: session_topic_map,
        brand_logo: session_topic_map.session.brand_logo.url.full,
        session_topic_name: session_topic_map.name,
        shapes: shapes
      })
  end

  def mini_survey(conn, %{"session_topic_id" => session_topic_id}) do
    session_topic =
      SessionTopicQueries.find(session_topic_id)
      |> Repo.one
      |> Phoenix.View.render_one(SessionTopicView, "show.json", as: :session_topic )

    header_title = "Voutes History - #{session_topic.session.account.name} / #{session_topic.session.name}"

    mini_surveys = QueriesMiniSurvey.report_query(session_topic.id, true)
    |> Repo.all
    |> Phoenix.View.render_many(MiniSurveyView, "show_with_answers.json", as: :mini_survey)

    conn |>
    put_layout("report.html") |>
    render("mini_surveys.html", %{
      header_title: header_title,
      brand_logo: session_topic.session.brand_logo.url.full,
      mini_surveys: mini_surveys,
      session_topic_name: session_topic.name,
    })
  end


  def filter_access(conn, opts) do
    case Mix.env do
      :dev ->
        conn
      _ ->
        KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
  end
end
