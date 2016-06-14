defmodule KlziiChat.Services.SessionReportingService do
  alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService, ResourceService}
  alias KlziiChat.{Repo, SessionTopicReport, SessionMember, Endpoint}

  import Ecto.Query, only: [from: 2]

  @upload_report_timeout 60_000

  def create_session_topic_report(_, _, _, report_format, :whiteboard, _) when report_format != :pdf, do: {:error, "pdf is the only format that is acceptable for whiteboard report"}

  def create_session_topic_report(session_id, session_member, session_topic_id, report_format, report_type, include_facilitator)
    when report_type in [:all, :star, :whiteboard] and report_format in [:txt, :csv, :pdf]    # TODO: :votes
  do
    with {:ok, %{id: session_topics_reports_id} = session_topics_report} <-  create_session_topics_reports_record(session_id, session_topic_id, report_type, include_facilitator, report_format),
         {:ok, report_name} <- get_report_name(report_type, session_topics_reports_id),
         create_report_params = [session_id, session_member.id, session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator],
         {:ok, _}  <- Task.start(__MODULE__, :create_report_asyc, create_report_params),
     do: {:ok, Repo.preload(session_topics_report, :resource)}
  end

  def create_session_topic_report(_, _, _, report_format, _, _) when report_format in [:txt, :csv, :pdf], do: {:error, "incorrect report type"}
  def create_session_topic_report(_, _, _, _, _, _), do: {:error, "incorrect report format"}

  def create_session_topics_reports_record(session_id, session_topic_id, :whiteboard, _, :pdf) do
    Repo.insert(%SessionTopicReport{
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      type: "whiteboard",
      facilitator: true,
      format: "pdf"
    })
  end

  def create_session_topics_reports_record(session_id, session_topic_id, report_type, include_facilitator, report_format) do
    Repo.insert(%SessionTopicReport{
      sessionId: session_id,
      sessionTopicId: session_topic_id,
      type: to_string(report_type),
      facilitator: include_facilitator,
      format: to_string(report_format)
    })
  end


  def get_report_name(:whiteboard, session_topics_reports_id), do: {:ok, "Session_topic_whiteboard_report_" <> to_string(session_topics_reports_id)}
  def get_report_name(report_type, session_topics_reports_id), do: {:ok, "Session_topic_messages_report_" <> to_string(session_topics_reports_id)}

  def get_account_user_id(session_member_id) do
    Repo.one(
      from sm in SessionMember,
      where: sm.id == ^session_member_id,
      select: sm.accountUserId
    )
  end

  def create_report_asyc(session_id, session_member_id, session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator) do
    star_only = if report_type == :star, do: true, else: false

    {:ok, report_file_path} = SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, star_only, !include_facilitator)
    upload_params = %{"type" => "file",
        "scope" => to_string(report_format),
        "file" => report_file_path,
        "name" => report_name}

    {:ok, session_topics_report} =
      Task.async(fn -> ResourceService.upload(upload_params, get_account_user_id(session_member_id)) end)
      |> Task.yield(@upload_report_timeout)
      |> update_session_topics_reports_record(session_topics_reports_id)

    session_topics_report = Repo.preload(session_topics_report, :resource)
    Endpoint.broadcast!( "sessions:#{session_id}", "session_topics_report_updated", session_topics_report)

    if File.exists?(report_file_path), do: File.rm(report_file_path)
  end


  def update_session_topics_reports_record({:ok, {:ok, resource}}, session_topics_reports_id) do
    session_topics_report = Repo.get(SessionTopicReport, session_topics_reports_id)
    session_topics_report = Ecto.Changeset.change(session_topics_report, status: "completed", resourceId: resource.id)

    Repo.update(session_topics_report)
  end

  def update_session_topics_reports_record(nil, session_topics_reports_id) do
    update_session_topics_reports_record({:error, "Report upload timeout"}, session_topics_reports_id)
  end

  def update_session_topics_reports_record({:exit, err}, session_topics_reports_id) do
    update_session_topics_reports_record({:error, err}, session_topics_reports_id)
  end

  def update_session_topics_reports_record({:error, err}, session_topics_reports_id) do
    session_topics_reports = Repo.get!(SessionTopicReport, session_topics_reports_id)
    session_topics_reports = Ecto.Changeset.change(session_topics_reports, status: "failed", message: err)

    Repo.update(session_topics_reports)
  end


  def get_session_topics_reports(session_id) do
    session_topics_reports =
      Repo.all(
        from str in SessionTopicReport,
        where: str.sessionId == ^session_id,
        preload: [:resource]
      )
      |> group_session_topics_reports()

    {:ok, session_topics_reports}
  end

  # sessionTopicId => format => type
  def group_session_topics_reports(reports) do
    Enum.reduce(reports, Map.new, fn (%{sessionTopicId: sessionTopicId, type: type, format: format} = report, resulting_map) ->
      Map.update(resulting_map, sessionTopicId, %{format => %{type => report}}, fn value ->
        Map.update(value, format, %{type => report}, &Map.put(&1, type, report))
      end)
    end)
  end

  def delete_session_topic_report(session_topic_report_id, session_member_id) do
    case Repo.get(SessionTopicReport, session_topic_report_id) do
      nil ->
        {:error, "Session Topic Report not found"}
      session_topic_report ->
        resource_id = session_topic_report.resourceId
        if resource_id != nil do
          account_user_id = get_account_user_id(session_member_id)
          Task.start(fn -> ResourceService.deleteByIds(account_user_id, [resource_id]) end)
        end
        Repo.delete(session_topic_report)
    end
  end

end
