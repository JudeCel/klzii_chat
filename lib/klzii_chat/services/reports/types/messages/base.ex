defmodule KlziiChat.Services.Reports.Types.Messages.Base do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionTopicView, SessionView, SessionTopic, Topic, Shape}
  alias KlziiChat.Services.Reports.Types.Messages.Formats
  alias KlziiChat.Queries.SessionTopic, as: SessionTopicQueries
  alias KlziiChat.Queries.Sessions, as: SessionQueries
  import Ecto.Query, only: [from: 2, join: 5]

  @spec default_fields() :: List.t[String.t]
  def default_fields() do
    ["First Name", "Comment", "Date", "Is Star", "Is Reply"]
  end

  @spec format_modeule(String.t) :: Module.t
  def format_modeule("pdf"), do: {:ok, Formats.Pdf}
  def format_modeule("csv"), do: {:ok, Formats.Csv}
  def format_modeule("txt"), do: {:ok, Formats.Txt}
  def format_modeule(format), do: {:error, "module for format #{format} not found"}

  @spec get_data(Map.t) :: {:ok, Map.t} | {:error, Map.t}
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

  @spec get_header_title(Map.t, Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_header_title(%{ name: name, account: %{ name: account_name } }, %{type: "messages_stars_only"}) do
    {:ok, "Chat History Stars Only- #{account_name} / #{name}"}
  end
  def get_header_title(%{ name: name, account: %{ name: account_name } }, %{type: "messages"}) do
    {:ok, "Chat History - #{account_name} / #{name}"}
  end
  def get_header_title(_, _) do
    {:error, %{not_reqired: "session account name or session name not reqired"}}
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
    |> join(:right, [st], t in Topic, st.topicId == t.id and t.default == false)
    |> Repo.all
    |> Repo.preload([messages: preload_messages_query(report), shapes: preload_shapes(report)])
  end
  def preload_session_topic(%{sessionTopicId: sessionTopicId} = report) do
    from(st in SessionTopic,
      right_join: t in assoc(st, :topic),
      where: st.id == ^sessionTopicId,
      where: t.default == false,
      preload: [messages: ^preload_messages_query(report), shapes: ^preload_shapes(report)]
    ) |> Repo.all
  end

  def preload_messages_query(%{type: "messages_stars_only"} = report) do
    includes_facilitator = !!get_in(report.includes, ["facilitator"])
    KlziiChat.Queries.Messages.session_topic_messages(report.sessionTopicId, [ star: true, facilitator: includes_facilitator ])
  end

  def preload_messages_query(report) do
    includes_facilitator = !!get_in(report.includes, ["facilitator"])
    KlziiChat.Queries.Messages.session_topic_messages(report.sessionTopicId, [ star: false, facilitator: includes_facilitator ])
  end

  def preload_shapes(_) do
      from(s in Shape,
      where: [eventType: "image"],
      order_by: [asc: :id],
      preload: [:session_member])
  end
end
