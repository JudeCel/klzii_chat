defmodule KlziiChat.Services.Reports.Types.Messages do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionTopicView, SessionView, SessionTopic, Session}
  alias KlziiChat.Queries.SessionTopic, as: SessionTopicQueries
  import Ecto.Query, only: [from: 2]

  @spec get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_data(report) do
    with {:ok, session} <- get_session(report),
    do:  {:ok, %{
              "session" => session,
              "header_title" => header_title(session)
            }
          }
  end

  def header_title(%{sessionTopicId: nil} = session), do: "Chat History - #{session.account.name} / #{session.name}"
  def header_title(session), do: "Chat History - #{session.account.name} / #{session.name}"

  def get_session(%{sessionId: session_id} = report) do
    session = from(s in Session,  where: s.id == ^session_id)
      |> Repo.one
      |> Repo.preload([:account, :brand_logo, :brand_project_preference ])
      |> preload_session_topic(report)
      |> Phoenix.View.render_one(SessionView, "report.json", as: :session)
    {:ok, session}
  end

  def preload_session_topic(query, %{sessionTopicId: nil} = report) do
    Repo.preload(query, [session_topics: [messages: preload_messages_query(report)]])
  end

  def preload_session_topic(query, %{sessionTopicId: sessionTopicId} = report) do
    session_topic_query = from(s in SessionTopic,
      where: s.id == ^sessionTopicId,
      preload: [messages: ^preload_messages_query(report)]
    )
    Repo.preload(query, [session_topics: session_topic_query])
  end

  def preload_messages_query(report) do
    only_star = get_in(report.scopes, ["only", "star"]) || false
    exclude_facilitator = get_in(report.scopes, ["exclude", "role", "facilitator"]) || false
    KlziiChat.Queries.Messages.session_topic_messages(report.sessionTopicId, [ star: only_star, facilitator: exclude_facilitator ])
  end
end
