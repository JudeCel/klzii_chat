defmodule KlziiChat.Reporting.PreviewController do
  alias KlziiChat.{Repo, SessionTopic, ShapeView, MiniSurveyView }
  alias KlziiChat.Queries.Messages, as: QueriesMessages
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  use KlziiChat.Web, :controller
  plug :filter_access

  def messages(conn, %{"session_topic_id" => session_topic_id}) do
    session_topic = Repo.get!(SessionTopic, session_topic_id)
      |> Repo.preload([session: [:account] ])

    messages =
      QueriesMessages.session_topic_messages(session_topic_id, [star: false, facilitator: false])
      |> Repo.all

      header_title = "Chat History - #{session_topic.session.account.name} / #{session_topic.session.name}"

      conn |>
      put_layout("report.html") |>
      render("messages.html", %{session_topic_name: session_topic.name,
        header_title: header_title, messages: messages
      })
  end

  def whiteboard(conn, %{"session_topic_id" => session_topic_id}) do
    session_topic = Repo.get!(SessionTopic, session_topic_id) |> Repo.preload([session: [:account] ])

    shapes =
      QueriesShapes.base_query(session_topic)
      |> Repo.all
      |> Phoenix.View.render_many(ShapeView, "shape.json", as: :shape)

      header_title = "Whiteboard History - #{session_topic.session.account.name} / #{session_topic.session.name}"


      conn |>
      put_layout("report.html") |>
      render("shapes.html", %{
        header_title: header_title,
        session_topic: session_topic,
        session_topic_name: session_topic.name,
        shapes: shapes
      })
  end

  def mini_survey(conn, %{"session_topic_id" => session_topic_id}) do
    session_topic = Repo.get!(SessionTopic, session_topic_id) |> Repo.preload([session: [:account] ])
    header_title = "Voutes History - #{session_topic.session.account.name} / #{session_topic.session.name}"

    mini_surveys = QueriesMiniSurvey.base_query(session_topic.id)
    |> Repo.all
    |> Phoenix.View.render_many(MiniSurveyView, "show_with_answers.json", as: :mini_survey)

    conn |>
    put_layout("report.html") |>
    render("mini_surveys.html", %{
      header_title: header_title,
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
