defmodule KlziiChat.Services.Reports.Types.Whiteboards do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionView, SessionTopic, Session}
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  import Ecto.Query, only: [from: 2]

  @spec get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_data(report) do
    with {:ok, session} <- get_session(report),
    do:  {:ok, %{ "session" => session, "header_title" => header_title(session) } }
  end

  def header_title(%{sessionTopicId: nil} = session), do: "Mini Surveys History - #{session.account.name} / #{session.name}"
  def header_title(session), do: "Mini Surveys History - #{session.account.name} / #{session.name}"

  def get_session(%{sessionId: session_id} = report) do
    session = from(s in Session,  where: s.id == ^session_id)
      |> Repo.one
      |> Repo.preload([:account, :brand_logo, :brand_project_preference ])
      |> preload_session_topic(report)
      |> Phoenix.View.render_one(SessionView, "report.json", as: :session)
    {:ok, session}
  end

  def preload_session_topic(query, %{sessionTopicId: nil} = report) do
    Repo.preload(query, [session_topics: [shapes: preload_shapes(report)]])
  end

  def preload_session_topic(query, %{sessionTopicId: sessionTopicId} = report) do
    session_topic_query = from(s in SessionTopic,
      where: s.id == ^sessionTopicId,
      preload: [mini_surveys: ^preload_shapes(report)]
    )
    Repo.preload(query, [session_topics: session_topic_query])
  end

  def preload_shapes(report) do
    QueriesShapes.base_query(%{ id: report.sessionTopicId })
  end
end
