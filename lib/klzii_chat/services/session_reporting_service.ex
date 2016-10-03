defmodule KlziiChat.Services.SessionReportingService do
  alias KlziiChat.Services.{SessionTopicReportingService, ResourceService, WhiteboardReportingService, MiniSurveysReportingService}
  alias KlziiChat.{Repo, SessionTopicReport, SessionMember, Endpoint}
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions

  import Ecto.Query, only: [from: 2]

  @save_report_timeout 30 * 60_000
  @upload_report_timeout 30 * 60_000

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

  @spec create_session_topic_report(integer, integer, integer, atom, atom, boolean) :: {:ok, Map.t} | {:error, String.t}
  def create_session_topic_report(_, _, _, report_format, :whiteboard, _) when report_format != :pdf do
     {:error, %{format: "pdf is the only format that is available for whiteboard reports"}}
   end
  @spec create_session_topic_report(integer, integer, integer, atom, atom, boolean) :: {:ok, Map.t} | {:error, String.t}
  def create_session_topic_report(session_id, session_member_id, session_topic_id, report_format, report_type, include_facilitator)
  when report_type in [:all, :star, :whiteboard, :votes] and report_format in [:txt, :csv, :pdf]
  do

    with {:ok, session_member} <- get_session_member(session_member_id),
         {:ok} <- check_report_create_permision(session_member),
         {:ok, report} <- create_session_topics_reports_record(session_id, session_topic_id, report_type, include_facilitator, report_format),
         {:ok, report_name} <- get_report_name(report_type, report.id),
         create_report_params = [session_id, session_member.accountUserId, report.id, session_topic_id, report_name, report_format, report_type, include_facilitator],
         {:ok, _}  <- Task.start(__MODULE__, :create_report_async, create_report_params),
    do:  {:ok, Repo.preload(report, :resource)}
  end

  @spec create_session_topic_report(integer, integer, integer, atom, atom, boolean) :: {:ok, Map.t} | {:error, String.t}
  def create_session_topic_report(_, _, _, _, _, _), do: {:error, %{format: "incorrect report format or type"}}

  @spec create_session_topics_reports_record(integer, integer, atom, boolean, atom) :: {atom, Map.t}
  def create_session_topics_reports_record(session_id, session_topic_id, report_type, include_facilitator, report_format) do
    Repo.insert(%SessionTopicReport{
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      type: to_string(report_type),
      facilitator: include_facilitator,
      format: to_string(report_format)
    })
  end


  @spec get_report_name(atom, integer) :: {:ok, String.t}
  def get_report_name(:whiteboard, report_id), do: {:ok, "STW_Report_" <> to_string(report_id)}

  @spec get_report_name(atom, integer) :: {:ok, String.t}
  def get_report_name(:votes, report_id), do: {:ok, "STMS_Report_" <> to_string(report_id)}

  @spec get_report_name(atom, integer) :: {:ok, String.t}
  def get_report_name(_, report_id), do: {:ok, "STM_Report_" <> to_string(report_id)}


  @spec create_report_async(integer, integer, integer, integer, String.t, atom, atom, boolean) :: {:ok, pid} | {:error, String.t}
  def create_report_async(session_id, account_user_id, report_id, session_topic_id, report_name, report_format, report_type, include_facilitator) do
    with  {:ok, report_file_path} <- save_report_async(report_type, report_name, report_format, session_topic_id, include_facilitator),
          {:ok, session_topics_report} <- upload_report_async(report_format, report_file_path, report_name, account_user_id)
    do
          {:ok, report} = update_session_topics_reports_record({:ok, session_topics_report}, report_id)
          broadcast_updated_report(session_id, report)
    else
          {:error, err} ->
            {:ok, report } = update_session_topics_reports_record({:error, err}, report_id)
            broadcast_updated_report(session_id, report)
    end
  end




  @spec broadcast_updated_report(integer, Map.t) :: no_return
  def broadcast_updated_report(session_id, report), do: Endpoint.broadcast!("sessions:#{session_id}", "session_topics_report_updated", Repo.preload(report, :resource))

  @spec save_report_async(integer, Strig.t, atom, integer, boolean) :: {:ok | :error, String.t}
  def save_report_async(report_type, report_name, report_format, session_topic_id, include_facilitator) do
    async_func =
      case report_type do
        :all ->
          fn -> SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, false, include_facilitator) end
        :star ->
          fn -> SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, true, include_facilitator) end
        :whiteboard ->
          fn -> WhiteboardReportingService.save_report(report_name, :pdf, session_topic_id) end
        :votes ->
          fn -> MiniSurveysReportingService.save_report(report_name, report_format, session_topic_id, include_facilitator) end
      end

    async_task =
      Task.async(fn ->
        try do
          async_func.()
        catch
          type, _ -> {:error, %{system: "Error creating report: #{to_string(type)}"}}
        end
      end)

    case Task.yield(async_task, @save_report_timeout) do
      {:ok, {:ok, report_file_path}} -> {:ok, report_file_path}
      {:ok, {:error, err}} -> {:error, err}
      nil -> {:error, %{system: "Report creation timeout " <> to_string(@save_report_timeout)}}
    end
  end

  @spec upload_report_async(atom, String.t, String.t, integer) :: {:ok | :error, String.t}
  def upload_report_async(report_format, report_file_path, report_name, account_user_id) do
    upload_params = %{ "type" => "file",
      "scope" => to_string(report_format),
      "file" => report_file_path,
      "name" => report_name }

    async_task = Task.async(fn ->
      try do
        ResourceService.upload(upload_params, account_user_id)
      catch
        type, _ -> {:error, %{system: "Error creating report: #{to_string(type)}}"}}
      end
    end)

    result = Task.yield(async_task, @upload_report_timeout)
    File.rm(report_file_path)
    case result do
      {:ok, {:ok, report_file_path}} -> {:ok, report_file_path}
      {:ok, {:error, err}} -> {:error, err}
      nil -> {:error, %{system: "Report upload timeout " <> to_string(@upload_report_timeout)}}
    end
  end


  @spec update_session_topics_reports_record({:ok, Map.t}, integer) :: {atom, Map.t}
  def update_session_topics_reports_record({:ok, resource}, report_id) do
    Repo.get!(SessionTopicReport, report_id)
    |> Ecto.Changeset.change(status: "completed", resourceId: resource.id, message: nil)
    |> Repo.update()
  end

  @spec update_session_topics_reports_record({:error, String.t}, integer) :: {atom, Map.t}
  def update_session_topics_reports_record({:error, err}, report_id) do
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

  @spec check_report_delete_permision(integer) :: :ok | {:error, String.t}
  def check_report_delete_permision(session_member) do
    SessionReportingPermissions.can_delete_report(session_member)
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
      "failed" -> Ecto.Changeset.change(report, deletedAt: Timex.now, resourceId: nil) |> Repo.update()
      _ -> Repo.delete(report)
    end
  end

  @spec recreate_session_topic_report(integer, integer) :: {:ok, Map.t} | {:error, String.t}
  def recreate_session_topic_report(report_id, session_member_id) do
    with  {:ok, report} <- delete_session_topic_report(report_id, session_member_id),
          {:ok, new_report} <- create_session_topic_report(report.sessionId, session_member_id, report.sessionTopicId, String.to_atom(report.format), String.to_atom(report.type), report.facilitator),
    do:   {:ok, new_report}
  end
end
