defmodule KlziiChat.Services.Reports.Types.Messages.Base do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionTopicView, SessionView, SessionTopic}
  alias KlziiChat.Services.Reports.Types.Messages.Formats
  alias KlziiChat.Queries.SessionTopic, as: SessionTopicQueries
  alias KlziiChat.Queries.Sessions, as: SessionQueries
  import Ecto.Query, only: [from: 2]

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
              "fields" => Enum.concat(default_fields(), report.includeFields) |> fields_list(session)
            }
          }
  end

  def fields_list(list, session) do
    case session do
      %{anonymous: true} ->
        List.insert_at(list, 0, "Anonymous")
      _ ->
        list
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
    |> Repo.all
    |> Repo.preload([messages: preload_messages_query(report)])
  end

  def preload_session_topic(%{sessionTopicId: sessionTopicId} = report) do
    from(st in SessionTopic,
      where: st.id == ^sessionTopicId,
      preload: [messages: ^preload_messages_query(report)]
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
end
