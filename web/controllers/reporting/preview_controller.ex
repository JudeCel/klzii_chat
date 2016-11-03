defmodule KlziiChat.Reporting.PreviewController do
  alias KlziiChat.{Repo, ShapeView, MiniSurveyView, SessionTopicView}
  alias KlziiChat.Queries.Messages, as: QueriesMessages
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  alias KlziiChat.Queries.SessionTopic,  as: SessionTopicQueries
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


  def filter_access(conn, opts) do
    case Mix.env do
      :dev ->
        conn
      _ ->
        KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
  end







  @spec preload_dependencies(%Message{} | [%Message{}]) :: %Message{} | [%Message{}]
  def preload_dependencies(message) do
    replies_replies_query = from(rpl in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, :replies])
    replies_query = from(st in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, replies: ^replies_replies_query])
    {:ok, Repo.preload(message, [:session_member, :votes, replies: replies_query])}
  end

  @spec preload_dependencies(%Message{} | [%Message{}],  Integer.t) :: %Message{} | [%Message{}]
  def preload_dependencies(message, session_member_id) do
    unread_messages_query = from(um in UnreadMessage, where: um.sessionMemberId == ^session_member_id)
    replies_replies_query = from(rpl in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, :replies, unread_messages: ^unread_messages_query])
    replies_query = from(st in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, unread_messages: ^unread_messages_query, replies: ^replies_replies_query])
    {:ok, Repo.preload(message, [:session_member, :votes, unread_messages: unread_messages_query, replies: replies_query])}
  end















end
