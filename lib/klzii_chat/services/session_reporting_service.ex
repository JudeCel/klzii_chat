defmodule KlziiChat.Services.SessionReportingService do
  alias KlziiChat.Services.{ResourceService}
  alias KlziiChat.{Repo, SessionTopicReport, SessionMember}
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions
  import KlziiChat.Helpers.MapHelper, only: [key_to_string: 1]
  import Ecto.Query, only: [from: 2]

  @spec get_session_member(integer) :: {atom, String.t}
  def get_session_member(session_member_id) do
    case Repo.get(SessionMember, session_member_id) do
      nil -> {:error, %{not_found: "No session member found with id: " <> session_member_id}}
      session_member -> {:ok, session_member}
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
    if type in ["messages", "whiteboards", "votes"]  do
      {:ok}
    else
      {:error, %{type: "incorrect report type"}}
    end
  end

  @spec validate_format(Map.t) :: :ok | {:error, String.t}
  def validate_format(%{"format" => format}) do
    if format in ["txt", "csv", "pdf"]  do
      {:ok}
    else
      {:error, %{format: "incorrect report format"}}
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
         {:ok, report} <- create_record(session_member.sessionId, payload),
         {:ok, report_name} <- Map.get(payload, "type", "") |> get_report_name(report.id),
    do:  {:ok, Repo.preload(report, :resource)}
  end

  @spec create_record(Integer, Map.t) :: {atom, Map.t}
  def create_record(session_id, payload) do
    params =
      Map.put(%{}, "sessionId", session_id)
      |> Map.merge(payload)
    SessionTopicReport.changeset(%SessionTopicReport{}, params)
    |> Repo.insert
  end


  @spec get_report_name(atom, integer) :: {:ok, String.t}
  def get_report_name("whiteboard", report_id), do: {:ok, "STW_Report_" <> to_string(report_id)}

  @spec get_report_name(atom, integer) :: {:ok, String.t}
  def get_report_name("votes", report_id), do: {:ok, "STMS_Report_" <> to_string(report_id)}

  @spec get_report_name(atom, integer) :: {:ok, String.t}
  def get_report_name(_, report_id), do: {:ok, "STM_Report_" <> to_string(report_id)}

  @spec set_status({:ok, Map.t} | {:error, String.t}, integer) :: {atom, Map.t}
  def set_status({:ok, resource}, report_id) do
    Repo.get!(SessionTopicReport, report_id)
    |> Ecto.Changeset.change(status: "completed", resourceId: resource.id, message: nil)
    |> Repo.update()
  end
  def set_status({:error, err}, report_id) do
    Repo.get!(SessionTopicReport, report_id)
    |> Ecto.Changeset.change(status: "failed", message: Poison.encode!(err) )
    |> Repo.update()
  end


  @spec get_session_topics_reports(integer, integer) :: {:ok, List.t} | {:error, String.t}
  def get_session_topics_reports(session_id, session_member_id) do
    {:ok, session_member} = get_session_member(session_member_id)
    case SessionReportingPermissions.can_get_reports(session_member) do
      {:ok} ->
        query =
          from str in SessionTopicReport,
          where: str.sessionId == ^session_id and is_nil(str.deletedAt),
          preload: [:resource]
        {:ok, Repo.all(query)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec delete_session_topic_report(integer, integer) :: {:ok, Map.t} | {:error, String.t}
  def delete_session_topic_report(report_id, session_member_id) do
    with  {:ok, session_member} <- get_session_member(session_member_id),
          {:ok} <- check_report_delete_permision(session_member),
          report = Repo.get(SessionTopicReport, report_id),
          {ok, deleted_report} <- check_delete_session_topic_report(report, session_member.accountUserId),
    do:   {ok, deleted_report}
  end

  @spec check_delete_session_topic_report(nil, integer) :: {:error, String.t}
  def check_delete_session_topic_report(nil, _), do: {:error, %{not_found: "Session Topic Report not found"}}

  @spec check_delete_session_topic_report(Map.t, integer) :: {atom, String.t}
  def check_delete_session_topic_report(report, account_user_id) do
    delete_resource_async(account_user_id, report.resourceId)
    delete_report(report)
  end

  @spec delete_resource_async(integer, nil) :: no_return
  def delete_resource_async(_, nil) do
    nil
  end

  @spec delete_resource_async(integer, integer) :: {:ok, pid}
  def delete_resource_async(account_user_id, resource_id) do
    Task.start(fn -> ResourceService.deleteByIds(account_user_id, [resource_id]) end)
  end

  @spec delete_report(Map.t) :: {atom, Map.t}
  def delete_report(report) do
    case report.status do
      "failed" ->
        Ecto.Changeset.change(report, deletedAt: Timex.now, resourceId: nil) |> Repo.update()
      _ ->
        Repo.delete(report)
    end
  end

  @spec recreate_report(integer, integer) :: {:ok, Map.t} | {:error, String.t}
  def recreate_report(report_id, session_member_id) do
    with  {:ok, report} <- delete_session_topic_report(report_id, session_member_id),
          {:ok, new_report} <- create_report(session_member_id, report),
    do:   {:ok, new_report}
  end
end
