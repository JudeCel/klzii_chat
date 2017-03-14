defmodule KlziiChat.Services.SessionReportingService do
  alias KlziiChat.Services.{ResourceService}
  alias KlziiChat.{Repo, SessionTopicsReport, SessionMember, Session, SessionTopic}
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions
  import KlziiChat.Helpers.MapHelper, only: [key_to_string: 1]
  import Ecto.Query, only: [from: 2, from: 1 ]

  @spec get_session_member(integer) :: {atom, String.t}
  def get_session_member(session_member_id) do

    case Repo.get(SessionMember, session_member_id) do
      nil -> {:error, %{not_found: "No session member found with id: " <> session_member_id}}
      session_member -> {:ok, Repo.preload(session_member, [:session])}
    end
  end

  @spec check_report_create_permision(integer) :: :ok | {:error, String.t}
  def check_report_create_permision(session_member) do
    SessionReportingPermissions.can_create_report(session_member)
  end

  @spec check_report_delete_permision(integer) :: :ok | {:error, String.t}
  def check_report_delete_permision(session_member) do
    SessionReportingPermissions.can_delete_report(session_member)
  end

  @spec validate_parametrs(Map.t) :: :ok | {:error, String.t}
  def validate_parametrs(payload) do
    with {:ok} <- validate_type(payload),
         {:ok} <- validate_format(payload),
         {:ok} <- validate_format_with_type(payload),
    do: {:ok }
  end

  @spec validate_type(Map.t) :: :ok | {:error, String.t}
  def validate_type(%{"type" => type}) do
    if type in ["statistic", "messages", "messages_stars_only", "whiteboards", "votes"]  do
      {:ok}
    else
      {:error, %{type: "incorrect report type: #{type}"}}
    end
  end

  @spec validate_format(Map.t) :: :ok | {:error, String.t}
  def validate_format(%{"format" => format}) do
    if format in ["txt", "csv", "pdf"]  do
      {:ok}
    else
      {:error, %{format: "incorrect report format: #{format}"}}
    end
  end

  @spec validate_format_with_type(Map.t) :: :ok | {:error, String.t}
  def validate_format_with_type(%{"format" => format, "type" => type}) do
    if type == "whiteboards" and format != "pdf"   do
      {:error, %{format: "pdf is the only format that is available for whiteboard reports"}}
    else
      {:ok}
    end
  end

  @spec create_report(Integer, Map.t) :: {:ok, Map.t} | {:error, String.t}
  def create_report(session_member_id, payload)do
    map = key_to_string(payload)
    case validate_parametrs(map) do
      {:ok} ->
        processed_report(session_member_id, map)
      {:error, reason} ->
        {:error,reason}
    end
  end

  @spec processed_report(Integer, Map.t) :: {:ok, Map.t} | {:error, String.t}
  def processed_report(session_member_id, payload) do

    with {:ok, session_member} <- get_session_member(session_member_id),
         {:ok} <- check_report_create_permision(session_member),
         {:ok, report_name} <- get_report_name(payload, session_member.session),
         {:ok, report} <- create_record(session_member.sessionId, Map.put(payload, "name", report_name)),
         {:ok, _} <- background_task(report),
    do:  {:ok, Repo.preload(report, [:resource])}
  end

  def background_task(report) do
    case Mix.env do
      :test ->
        {:ok, "Running in Test ENV"}
      _ ->
        Exq.enqueue(Exq, "report_#{report.format}", KlziiChat.BackgroundTasks.Reports.SessionTopicReport, [report.id])
    end
  end

  @spec create_record(Integer, Map.t) :: {atom, Map.t}
  def create_record(session_id, payload) do
    params =
      Map.put(%{}, "sessionId", session_id)
      |> Map.merge(payload)
    SessionTopicsReport.changeset(%SessionTopicsReport{}, params)
    |> Repo.insert
  end

  def normalize_name(name) do
    String.replace(name, " ", "_") <> to_string(:os.system_time(:millisecond))
  end

  @spec get_report_name(Map.t, String.t) :: {:ok, String.t}
  def get_report_name(%{"sessionTopicId" => sessionTopicId} = payload, session) when is_nil(sessionTopicId) do
    generate_fiele_name(payload, session)
  end
  def get_report_name(%{"sessionTopicId" => sessionTopicId} = payload, _session) do
    sessionTopic = Repo.get(SessionTopic, sessionTopicId)
    generate_fiele_name(payload, sessionTopic)
  end
  def get_report_name(payload, session), do: generate_fiele_name(payload, session)

  @spec get_report_name(Map.t, String.t) :: {:ok, String.t}
  def generate_fiele_name(%{"type" => "messages"}, %{name: name}), do: {:ok, "Messages Report #{name}_" |> normalize_name}
  def generate_fiele_name(%{"type" => "messages_stars_only"}, %{name: name}), do: {:ok, "Messages Report #{name}_" |> normalize_name}
  def generate_fiele_name(%{"type" =>"whiteboards"}, %{name: name}), do: {:ok, "Whiteboards Report #{name}_" |> normalize_name}
  def generate_fiele_name(%{"type" =>"votes"}, %{name: name}), do: {:ok, "Votes Report #{name}_" |> normalize_name}
  def generate_fiele_name(%{"type" =>"statistic"}, %{name: name}), do: {:ok, "Statistic Report #{name}_" |> normalize_name}
  def generate_fiele_name(_, _), do: {:ok, "Session_Report" |> normalize_name}

  # TODO check if used anymore
  @spec set_status({:ok, Map.t} | {:error, String.t}, integer) :: {atom, Map.t}
  def set_status({:ok, resource}, report_id) do
    Repo.get!(SessionTopicsReport, report_id)
    |> Ecto.Changeset.change(status: "completed", resourceId: resource.id, message: nil)
    |> Repo.update()
  end
  def set_status({:error, err}, report_id) do
    Repo.get!(SessionTopicsReport, report_id)
    |> Ecto.Changeset.change(status: "failed", message: Poison.encode!(err) )
    |> Repo.update()
  end

  def clean_up_by_resource_ids(ids) do
    from(str in SessionTopicsReport, where: str.resourceId in ^ids )
    |> Repo.delete_all()
  end

  def delete_all() do
    query = from(str in SessionTopicsReport)

    Repo.all(query)
    |> Repo.preload([:resource])
    |> Enum.map(fn(report) ->
        ResourceService.deleteByIds([report.resourceId])
     end)
     Repo.delete_all(query)
  end

  @spec get_session_topics_reports(integer, integer) :: {:ok, List.t} | {:error, String.t}
  def get_session_topics_reports(session_id, session_member_id) do
    {:ok, session_member} = get_session_member(session_member_id)
    case SessionReportingPermissions.can_get_reports(session_member) do
      {:ok} ->
        reports =
          from(str in SessionTopicsReport,
          where: str.sessionId == ^session_id and is_nil(str.deletedAt),
          preload: [:resource, session: [:participant_list]])
          |> Repo.all
        {:ok, reports}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec delete_session_topic_report(integer, integer) :: {:ok, Map.t} | {:error, String.t}
  def delete_session_topic_report(report_id, session_member_id) do
    with  {:ok, session_member} <- get_session_member(session_member_id),
          {:ok} <- check_report_delete_permision(session_member),
          report = Repo.get!(SessionTopicsReport, report_id),
          {:ok, deleted_report} <- check_delete_session_topic_report(report, session_member.accountUserId),
    do:   {:ok, deleted_report}
  end

  @spec check_delete_session_topic_report(nil, integer) :: {:error, String.t}
  def check_delete_session_topic_report(nil, _), do: {:error, %{not_found: "Session Topic Report not found"}}

  @spec check_delete_session_topic_report(Map.t, integer) :: {atom, String.t}
  def check_delete_session_topic_report(report, account_user_id) do
    {:ok, deleted_report} = delete_report(report)
    delete_resource_async(account_user_id, report.resourceId)
    {:ok, Map.delete(deleted_report, :resourceId)}
  end

  @spec delete_resource_async(integer, nil) :: no_return
  def delete_resource_async(_, nil) do
    nil
  end

  @spec delete_resource_async(integer, integer) :: {:ok, pid}
  def delete_resource_async(account_user_id, resource_id) do
    ResourceService.deleteByIds(account_user_id, [resource_id])
  end

  @spec delete_report(Map.t) :: {atom, Map.t}
  def delete_report(report) do
    Repo.delete(report)
  end

  @spec recreate_report(integer, integer) :: {:ok, Map.t} | {:error, String.t}
  def recreate_report(report_id, session_member_id) do
    with  {:ok, report} <- delete_session_topic_report(report_id, session_member_id),
          {:ok, new_report} <- create_report(session_member_id, report),
    do:   {:ok, new_report}
  end

  @spec set_failed(any, integer) :: {atom, Map.t}
  def set_failed(reason, report_id) do
    Repo.get!(SessionTopicsReport, report_id)
    |> Ecto.Changeset.change(status: "failed", message: Poison.encode!(reason) )
    |> Repo.update()
  end

  def get_session_contact_list(session_id) do
    session =
      Repo.get(Session, session_id)
      |>  Repo.preload([:participant_list])
      {:ok, session}
  end
end
