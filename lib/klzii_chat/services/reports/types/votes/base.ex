defmodule KlziiChat.Services.Reports.Types.Votes.Base do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionTopicView, SessionView, SessionTopic, Session}
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  import Ecto.Query, only: [from: 2]

  @spec default_fields() :: List.t[String.t]
  def default_fields() do
    ["Title", "Question", "First Name", "Answer", "Date" ]
  end

  def get_data(report) do
    with {:ok, session} <- get_session(report),
         {:ok, header_title} <- get_header_title(session),
         {:ok, session_topics} <- get_session_topics(report),
    do:  {:ok, %{
              "session" => session,
              "session_topics" => session_topics,
              "header_title" => header_title,
              "default_fields" => default_fields()
            }
          }
  end

  def get_header_title(%{sessionTopicId: nil} = session) do
    {:ok, "Mini Surveys History - #{session.account.name} / #{session.name}"}
  end
  def get_header_title(session) do
    {:ok, "Mini Surveys History - #{session.account.name} / #{session.name}"}
  end

  @spec get_session(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_session(%{sessionId: session_id} = report) do
    session = from(s in Session,  where: s.id == ^session_id)
      |> Repo.one
      |> Repo.preload([:account, :brand_logo, :brand_project_preference, [participant_list: [:contact_list_users]] ])
      |> Phoenix.View.render_one(SessionView, "report.json", as: :session)
    {:ok, session}
  end
  def get_session(_), do: {:error, %{not_reqired: "session id not reqired"}}


  def get_session_topics(report) do
    data =
      preload_session_topic(report)
      |> Phoenix.View.render_many(SessionTopicView, "report.json", as: :session_topic)
    {:ok, data}
  end

  def get_session_topics(report) do
    data =
      preload_session_topic(report)
      |> Phoenix.View.render_many(SessionTopicView, "report.json", as: :session_topic)
    {:ok, data}
  end

  def preload_session_topic(%{sessionTopicId: nil, sessionId: session_id} = report) do
    from(st in SessionTopic,
      where: st.sessionId == ^session_id,
      preload: [mini_surveys: ^preload_mini_survey_query(report)]
    ) |> Repo.all
  end

  def preload_session_topic(%{sessionTopicId: sessionTopicId} = report) do
    from(st in SessionTopic,
      where: st.id == ^sessionTopicId,
      preload: [mini_surveys: ^preload_mini_survey_query(report)]
    ) |> Repo.all
  end

  def preload_mini_survey_query(report) do
    exclude_facilitator = get_in(report.includes, ["facilitator"]) || false
    QueriesMiniSurvey.report_query(report.sessionTopicId, exclude_facilitator)
  end
end
