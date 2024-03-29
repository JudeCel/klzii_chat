defmodule KlziiChat.Services.Reports.Types.Whiteboards.Base do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.Services.Reports.Types.Whiteboards.{Formats}
  alias KlziiChat.{Repo, SessionView, SessionTopic, SessionTopicView}
  alias KlziiChat.Queries.SessionTopic, as: SessionTopicQueries
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  alias KlziiChat.Queries.Sessions, as: SessionQueries
  import Ecto.Query, only: [from: 2]

  @spec default_fields() :: List.t[String.t]
  def default_fields() do
    []
  end

  @spec format_modeule(String.t) :: Module.t
  def format_modeule("pdf"), do: {:ok, Formats.Pdf}
  def format_modeule(format), do: {:error, "module for format #{format} not found"}

  @spec get_data(Map.t) :: {:ok , Module.t | :error, String.t}
  def get_data(report) do
    with {:ok, session} <- get_session(report),
         {:ok, header_title} <- get_header_title(session, report),
         {:ok, session_topics} <- get_session_topics(report),
    do:  {:ok, %{
              "session" => session,
              "session_topics" => session_topics,
              "header_title" => header_title,
              "fields" => Enum.concat(default_fields(), report.includeFields)
            }
          }
  end

  @spec get_header_title(Map.t, Map.t) :: {:ok, String.t}
  def get_header_title(%{sessionTopicId: nil} = session, _) do
    {:ok, "Whiteboards History - #{session.account.name} / #{session.name}"}
  end
  def get_header_title(session, _) do
    {:ok, "Whiteboard History - #{session.account.name} / #{session.name}"}
  end

  @spec get_session(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_session(%{sessionId: session_id}) do
    session = SessionQueries.find_for_report(session_id)
      |> Repo.one
      |> Phoenix.View.render_one(SessionView, "report.json", as: :session)
    {:ok, session}
  end
  def get_session(_), do: {:error, %{not_reqired: "session id not reqired"}}

  @spec get_session_topics(Map.t) :: {:ok, Map.t}
  def get_session_topics(report) do
    data =
      preload_session_topic(report)
      |> Phoenix.View.render_many(SessionTopicView, "report.json", as: :session_topic)
    {:ok, data}
  end

  @spec preload_session_topic(Map.t) :: Map.t
  def preload_session_topic(%{sessionTopicId: nil, sessionId: session_id} = report) do
    SessionTopicQueries.all(session_id)
    |> Repo.all
    |> Repo.preload([shapes: preload_shapes(report)])
  end
  def preload_session_topic(%{sessionTopicId: sessionTopicId} = report) do
    from(st in SessionTopic,
      where: st.id == ^sessionTopicId,
      preload: [shapes: ^preload_shapes(report)]
    ) |> Repo.all
  end

  @spec preload_session_topic(Map.t) :: Ecto.Query.t
  def preload_shapes(report) do
    QueriesShapes.base_query(%{ sessionTopicId: report.sessionTopicId })
  end
end
