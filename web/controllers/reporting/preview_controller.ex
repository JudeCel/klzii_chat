defmodule KlziiChat.Reporting.PreviewController do
  alias KlziiChat.{Repo, ShapeView, MiniSurveyView, SessionTopicView}
  alias KlziiChat.Queries.Messages, as: QueriesMessages
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  alias KlziiChat.Queries.SessionTopic,  as: SessionTopicQueries
  use KlziiChat.Web, :controller
  plug :filter_access

  def messages(conn, %{"session_id" => session_id, "session_topic_id" => session_topic_id}) do
    report = %{
      type: "messages",
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      includes: %{"facilitator" => true},
      includeFields: []
    }
    {:ok, data } = KlziiChat.Services.Reports.Types.Messages.Base.get_data(report)

    conn |>
      put_layout("report.html") |>
      render("session_topics_messages.html", %{
        session_topics: get_in(data, ["session_topics"]),
        session: get_in(data, ["session"]),
        brand_logo: get_in(data, ["session", :brand_logo]),
        header_title: get_in(data, ["header_title"]),
      })
  end

  def messages_stars_only(conn, %{"session_id" => session_id, "session_topic_id" => session_topic_id}) do
    report = %{
      type: "messages_stars_only",
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      includes: %{"facilitator" => true},
      includeFields: []
    }
    {:ok, data } = KlziiChat.Services.Reports.Types.Messages.Base.get_data(report)

    conn |>
      put_layout("report.html") |>
      render("session_topics_messages.html", %{
        session_topics: get_in(data, ["session_topics"]),
        session: get_in(data, ["session"]),
        brand_logo: get_in(data, ["session", :brand_logo]),
        header_title: get_in(data, ["header_title"]),
      })
  end


  def whiteboard(conn, %{"session_id" => session_id, "session_topic_id" => session_topic_id}) do
    report = %{
      type: "whiteboards",
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      includes: %{"facilitator" => true},
      includeFields: []
    }
    {:ok, data } = KlziiChat.Services.Reports.Types.Whiteboards.Base.get_data(report)

    conn |>
      put_layout("report.html") |>
      render("session_topics_whiteboards.html", %{
        session_topics: get_in(data, ["session_topics"]),
        session: get_in(data, ["session"]),
        brand_logo: get_in(data, ["session", :brand_logo]),
        header_title: get_in(data, ["header_title"]),
      })
  end

  def mini_survey(conn, %{"session_id" => session_id, "session_topic_id" => session_topic_id}) do
    report = %{
      type: "votes",
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      includes: %{"facilitator" => true},
      includeFields: []
    }
    {:ok, data } = KlziiChat.Services.Reports.Types.Votes.Base.get_data(report)

    conn |>
      put_layout("report.html") |>
      render("session_topics_mini_surveys.html", %{
        session_topics: get_in(data, ["session_topics"]),
        session: get_in(data, ["session"]),
        brand_logo: get_in(data, ["session", :brand_logo]),
        header_title: get_in(data, ["header_title"]),
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
