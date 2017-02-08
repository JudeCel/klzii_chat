defmodule KlziiChat.Reporting.PreviewController do
  use KlziiChat.Web, :controller
  plug :filter_access

  def messages(conn, %{"session_id" => session_id} = params) do
    report = %{
      type: "messages",
      sessionId: session_id,
      sessionTopicId: params["session_topic_id"],
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

  def messages_stars_only(conn, %{"session_id" => session_id} = params) do
    report = %{
      type: "messages_stars_only",
      sessionId: session_id,
      sessionTopicId: params["session_topic_id"],
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


  def whiteboard(conn, %{"session_id" => session_id} = params) do
    report = %{
      type: "whiteboards",
      sessionId: session_id,
      sessionTopicId: params["session_topic_id"],
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

  def mini_survey(conn, %{"session_id" => session_id} = params) do
    report = %{
      type: "votes",
      sessionId: session_id,
      sessionTopicId: params["session_topic_id"],
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

  def recruiter_survey_stats(conn, %{"id" => id}) do
    report = %{
      id: id,
      type: "recruiter_survey_stats"
    }
    {:ok, data } = KlziiChat.Services.Reports.Types.RecruiterSurvey.Base.get_data(report)

    conn |>
      put_layout("report.html") |>
      render("recruiter_survey_stats.html", %{
        recruiter_survey: get_in(data, ["recruiter_survey"]),
        survey_questions_stats: get_in(data, ["survey_questions_stats"]),
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
