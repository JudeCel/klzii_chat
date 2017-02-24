defmodule KlziiChat.Services.Reports.Types.Votes.Base do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionTopicView, SessionView, SessionTopic}
  alias KlziiChat.Services.Reports.Types.Votes.{Formats}
  alias KlziiChat.Queries.SessionTopic, as: SessionTopicQueries
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  alias KlziiChat.Queries.Sessions, as: SessionQueries
  import Ecto.Query, only: [from: 2]

  @spec default_fields() :: List.t[String.t]
  def default_fields() do
    ["Title", "Question", "First Name", "Answer", "Date" ]
  end

  @spec format_modeule(String.t) :: Module.t
  def format_modeule("pdf"), do: {:ok, Formats.Pdf}
  def format_modeule("csv"), do: {:ok, Formats.Csv}
  def format_modeule(format), do: {:error, "module for format #{format} not found"}

  def get_data(report) do
    with {:ok, session} <- get_session(report),
         {:ok, header_title} <- get_header_title(session, report),
         {:ok, session_topics} <- get_session_topics(report),
    do:  {:ok, %{
              "session" => session,
              "session_topics" => session_topics,
              "header_title" => header_title,
              "fields" => fields_list(report.includeFields, session)
            }
          }
  end

  @spec fields_list(List.t, Map.t) :: List.t[String.t]
  def fields_list(list, session) do
    def_list = Enum.concat(default_fields(), list)
    case session do
      %{anonymous: true} ->
        List.insert_at(def_list, 0, "Anonymous")
      _ ->
        def_list
    end
  end

  @spec get_header_title(Map.t, Map.t) :: {:ok, String.t}
  def get_header_title(%{sessionTopicId: nil} = session, _) do
    {:ok, "Mini Surveys History - #{session.account.name} / #{session.name}"}
  end
  def get_header_title(session, _) do
    {:ok, "Mini Surveys History - #{session.account.name} / #{session.name}"}
  end

  @spec get_session(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_session(%{sessionId: session_id}) do
    session = SessionQueries.find_for_report(session_id)
      |> Repo.one
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

  def preload_session_topic(%{sessionTopicId: nil, sessionId: session_id} = report) do
    SessionTopicQueries.all(session_id)
    |> Repo.all
    |> Repo.preload([mini_surveys: preload_mini_survey_query(report)])
  end

  def preload_session_topic(%{sessionTopicId: sessionTopicId} = report) do
    from(st in SessionTopic,
      where: st.id == ^sessionTopicId,
      preload: [mini_surveys: ^preload_mini_survey_query(report)]
    ) |> Repo.all
  end

  def preload_mini_survey_query(report) do
    includes_facilitator = !get_in(report.includes, ["facilitator"])
    QueriesMiniSurvey.report_query(report.sessionTopicId, !includes_facilitator)
  end
end
