defmodule KlziiChat.Services.Reports.Types.Messages do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionTopicView, SessionView, SessionTopic, Session}
  alias KlziiChat.Queries.SessionTopic, as: SessionTopicQueries
  import Ecto.Query, only: [from: 2]

  @spec get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_data(report) do
    with {:ok, session} <- get_session(report),
         {:ok, header_title} <- get_header_title(session),
         {:ok, session_topics} <- get_session_topics(report),
         {:ok, participent_list_data} <- get_data_from_participent_list(report, session),
    do:  {:ok, %{
              "session" => session,
              "session_topics" => session_topics,
              "participent_list_data" => participent_list_data,
              "header_title" => header_title
            }
          }
  end

  @spec get_header_title(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_header_title(%{ name: name, account: %{ name: account_name } }) do
    {:ok, "Chat History - #{account_name} / #{name}"}
  end
  def get_header_title(%{ name: name, account: %{ name: account_name } }) do
    {:ok, "Chat History - #{account_name} / #{name}"}
  end
  def get_header_title(_) do
    {:error, %{not_reqired: "session account name or session name not reqired"}}
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

  @spec get_participent_list_fields(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_participent_list_fields(%{participant_list: %{customFields: customFields, defaultFields: defaultFields }}) do
    {:ok, %{customFields: customFields, defaultFields: defaultFields}}
  end
  def get_participent_list_fields(_) do
    {:error, %{not_reqired: "participant list not preloaded in session"}}
  end

  @spec get_data_from_participent_list(Map.t, Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_data_from_participent_list(report, session) do
    with {:ok, participent_list_fields} <- get_participent_list_fields(session),
    do: {:ok, %{}}
  end

  def preload_session_topic(%{sessionTopicId: nil, sessionId: session_id} = report) do
    from(st in SessionTopic,
      where: st.sessionId == ^session_id,
      preload: [messages: ^preload_messages_query(report)]
    ) |> Repo.all
  end

  def preload_session_topic(%{sessionTopicId: sessionTopicId} = report) do
    from(st in SessionTopic,
      where: st.id == ^sessionTopicId,
      preload: [messages: ^preload_messages_query(report)]
    ) |> Repo.all
  end

  def preload_messages_query(report) do
    only_star = get_in(report.scopes, ["only", "star"]) || false
    exclude_facilitator = get_in(report.scopes, ["exclude", "role", "facilitator"]) || false
    KlziiChat.Queries.Messages.session_topic_messages(report.sessionTopicId, [ star: only_star, facilitator: exclude_facilitator ])
  end
end
