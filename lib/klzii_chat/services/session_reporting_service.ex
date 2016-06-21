defmodule KlziiChat.Services.SessionReportingService do
  alias KlziiChat.Services.{SessionTopicReportingService, ResourceService, WhiteboardReportingService}
  alias KlziiChat.{Repo, SessionTopicReport, SessionMember, Endpoint}
  alias KlziiChat.Services.Permissions.SessionReporting, as: SessionReportingPermissions

  import Ecto.Query, only: [from: 2]

  @save_report_timeout 30 * 60_000
  @upload_report_timeout 30 * 60_000

  def get_session_member(session_member_id) do
    case Repo.get(SessionMember, session_member_id) do
      nil -> {:error, "No session member found with id: " <> session_member_id}
      session_member -> {:ok, session_member}
    end
  end

  def check_report_create_permision(session_member) do
    if SessionReportingPermissions.can_create_report(session_member), do: :ok, else: {:error, "Action not allowed!"}
  end


  def create_session_topic_report(_, _, _, report_format, :whiteboard, _) when report_format != :pdf, do: {:error, "pdf is the only format that is available for whiteboard reports"}

  def create_session_topic_report(session_id, session_member_id, session_topic_id, report_format, report_type, include_facilitator)
  when report_type in [:all, :star, :whiteboard] and report_format in [:txt, :csv, :pdf]    # TODO: :votes
  do
    with {:ok, session_member} <- get_session_member(session_member_id),
         :ok <- check_report_create_permision(session_member),
         {:ok, report} <- create_session_topics_reports_record(session_id, session_topic_id, report_type, include_facilitator, report_format),
         {:ok, report_name} <- get_report_name(report_type, report.id),
         create_report_params = [session_id, session_member.accountUserId, report.id, session_topic_id, report_name, report_format, report_type, include_facilitator],
         {:ok, _}  <- Task.start(__MODULE__, :create_report_async, create_report_params),
    do:  {:ok, Repo.preload(report, :resource)}
  end

  def create_session_topic_report(_, _, _, _, _, _), do: {:error, "incorrect report format or type"}

  def create_session_topics_reports_record(session_id, session_topic_id, report_type, include_facilitator, report_format) do
    Repo.insert(%SessionTopicReport{
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      type: to_string(report_type),
      facilitator: include_facilitator,
      format: to_string(report_format)
    })
  end


  def get_report_name(:whiteboard, report_id), do: {:ok, "Session_topic_whiteboard_report_" <> to_string(report_id)}
  def get_report_name(_, report_id), do: {:ok, "Session_topic_messages_report_" <> to_string(report_id)}


  def create_report_async(session_id, account_user_id, report_id, session_topic_id, report_name, report_format, report_type, include_facilitator) do
    report_processing_result =
      with {:ok, report_file_path} <- save_report_async(report_type, report_name, report_format, session_topic_id, include_facilitator),
           {:ok, session_topics_report} <- upload_report_async(report_format, report_file_path, report_name, account_user_id),
       do: {:ok, session_topics_report}

    {:ok, report} = update_session_topics_reports_record(report_processing_result, report_id)
    Endpoint.broadcast!("sessions:#{session_id}", "session_topics_report_updated", Repo.preload(report, :resource))
  end

  def save_report_async(report_type, report_name, report_format, session_topic_id, include_facilitator) do
    async_func =
      if report_type == :whiteboard do
        fn -> WhiteboardReportingService.save_report(report_name, :pdf, session_topic_id) end
      else
        filter_star = if report_type == :star, do: true, else: false
        fn -> SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, filter_star, include_facilitator) end
      end

    async_task =
      Task.async(fn ->
        try do
          async_func.()
        catch
          type, _ -> {:error, "Error creating report: #{to_string(type)}"}
        end
      end)

    case Task.yield(async_task, @save_report_timeout) do
      {:ok, {:ok, report_file_path}} -> {:ok, report_file_path}
      {:ok, {:error, err}} -> {:error, err}
      nil -> {:error, "Report creation timeout " <> to_string(@save_report_timeout)}
    end
  end

  def upload_report_async(report_format, report_file_path, report_name, account_user_id) do
    upload_params = %{ "type" => "file",
      "scope" => to_string(report_format),
      "file" => report_file_path,
      "name" => report_name }

    async_task = Task.async(fn ->
      try do
        ResourceService.upload(upload_params, account_user_id)
      catch
        type, _ -> {:error, "Error creating report: #{to_string(type)}"}
      end
    end)

    result = Task.yield(async_task, @upload_report_timeout)
    File.rm(report_file_path)
    case result do
      {:ok, {:ok, report_file_path}} -> {:ok, report_file_path}
      {:ok, {:error, err}} -> {:error, err}
      nil -> {:error, "Report upload timeout " <> to_string(@upload_report_timeout)}
    end
  end

  def update_session_topics_reports_record({:ok, resource}, report_id) do
    Repo.get(SessionTopicReport, report_id)
    |> Ecto.Changeset.change(status: "completed", resourceId: resource.id, message: nil)
    |> Repo.update()
  end

  def update_session_topics_reports_record({:error, err}, report_id) do
    Repo.get!(SessionTopicReport, report_id)
    |> Ecto.Changeset.change(status: "failed", message: err)
    |> Repo.update()
  end

  def get_session_topics_reports(session_id, session_member_id) do
    {:ok, session_member} = get_session_member(session_member_id)
    if SessionReportingPermissions.can_get_reports(session_member) do
      query = from(str in SessionTopicReport, where: str.sessionId == ^session_id, preload: [:resource])
      {:ok, Repo.all(query)}
    else
      {:error, "Action not allowed!"}
    end
  end

  def delete_session_topic_report(report_id, session_member_id) do
    {:ok, session_member} = get_session_member(session_member_id)
    if SessionReportingPermissions.can_delete_report(session_member) do
      delete_report(report_id, session_member.accountUserId)
    else
      {:error, "Action not allowed!"}
    end
  end

  def delete_report(report_id, account_user_id) do
    case Repo.get(SessionTopicReport, report_id) do
      nil ->
        {:error, "Session Topic Report not found"}
      report ->
        if report.resourceId != nil, do: Task.start(fn -> ResourceService.deleteByIds(account_user_id, [report.resourceId]) end)
        case report.status do
          "failed" -> Ecto.Changeset.change(report, deletedAt: Ecto.DateTime.utc(), resourceId: nil) |> Repo.update()
          _ -> Repo.delete(report)
        end
    end
  end

  def recreate_session_topic_report(report_id, session_member_id) do
    with {:ok, session_member} <- get_session_member(session_member_id),
         {:ok, report} <- delete_report(report_id, session_member.accountUserId),
    do:  create_session_topic_report(report.sessionId, session_member_id, report.sessionTopicId, String.to_atom(report.format), String.to_atom(report.type), report.facilitator)
  end
end
