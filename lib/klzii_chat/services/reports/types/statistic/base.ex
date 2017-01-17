defmodule KlziiChat.Services.Reports.Types.Statistic.Base do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  alias KlziiChat.{Repo, SessionTopicView, SessionView, SessionTopic, SessionMember, Message}
  alias KlziiChat.Services.Reports.Types.Statistic.Formats
  alias KlziiChat.Queries.SessionTopic, as: SessionTopicQueries
  alias KlziiChat.Queries.Sessions, as: SessionQueries
  import Ecto.Query, only: [from: 2]

  @spec default_fields() :: List.t[String.t]
  def default_fields() do
    []
  end

  @spec format_modeule(String.t) :: Module.t
  def format_modeule("csv"), do: {:ok, Formats.Csv}
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

  def get_header_title(%{ name: name, account: %{ name: account_name } }, %{type: "statistic"}) do
    {:ok, "Chat Room Statistics - #{account_name} / #{name}"}
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
    preload_statistic(report)
  end

  # from(p in Post, group_by: :category, select: {p.category, count(p.id)})

  def preload_statistic(%{sessionId: session_id} = report) when is_integer(session_id) do
    from(sm in SessionMember,
      left_join: st in SessionTopic, on: st.sessionId == sm.sessionId,
      left_join: m in Message, on: sm.id == m.sessionMemberId,
      where: sm.sessionId == ^session_id,
      group_by: [sm.id, m.id, st.name],
      select: {sm.id, count(m.id), st.name }
    )
    |> Repo.all
  end
  def preload_statistic(_) do: {:error, "no session Id for statisitc in report"}
end
