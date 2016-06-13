defmodule KlziiChat.Services.SessionReportingService do
  alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService, ResourceService}
  alias KlziiChat.{Repo, SessionTopicReport, SessionMember}

  @upload_report_timeout 60_000

  def create_session_topic_report(_, _, report_format, :whiteboard, _) when report_format != :pdf, do: {:error, "pdf is the only format that is acceptable for whiteboard report"}

  def create_session_topic_report(session_member_id, session_topic_id, report_format, report_type, include_facilitator)
    when report_type in [:all, :star, :whiteboard] and report_format in [:txt, :csv, :pdf]    # TODO: :votes
  do
    with {:ok, %{id: session_topics_reports_id}} <-  create_session_topics_reports_record(session_topic_id, session_member_id, report_type, include_facilitator, report_format),
         {:ok, report_name} <- get_report_name(report_type, session_topics_reports_id),
         create_report_params = [session_member_id, session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator],
         {:ok, _}  <- Task.start(__MODULE__, :create_report_asyc, create_report_params),
     do: {:ok, session_topics_reports_id}
  end

  def create_session_topic_report(_, _, report_format, _, _) when report_format in [:txt, :csv, :pdf], do: {:error, "incorrect report type"}
  def create_session_topic_report(_, _, _, _, _), do: {:error, "incorrect report format"}

  def create_session_topics_reports_record(session_topic_id, session_member_id, :whiteboard, include_facilitator, :pdf) do
    Repo.insert(%SessionTopicReport{
      sessionMemberId: session_member_id,
      sessionTopicId: session_topic_id,
      type: "whiteboard",
      facilitator: true,
      format: "pdf"
    })
  end

  def create_session_topics_reports_record(session_topic_id, session_member_id, report_type, include_facilitator, report_format) do
    Repo.insert(%SessionTopicReport{
      sessionMemberId: session_member_id,
      sessionTopicId: session_topic_id,
      type: to_string(report_type),
      facilitator: include_facilitator,
      format: report_format
    })
  end

  def get_report_name(:whiteboard, session_topics_reports_id), do: {:ok, "Session_topic_whiteboard_report_" <> to_string(session_topics_reports_id)}
  def get_report_name(report_type, session_topics_reports_id), do: {:ok, "Session_topic_messages_report_" <> to_string(session_topics_reports_id)}


  def create_report_asyc(session_member_id, session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator) do
    star_only = if report_type == :star, do: true, else: false
    account_user_id = Repo.get(
      from sm in SessionMember,
      where: sm.id == ^session_member_id,
      select: sm.accountUserId
    )

    {:ok, report_file_path} <- SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, star_only, !include_facilitator)
    upload_params = [
      %{"type" => "file",
        "scope" => to_string(report_format),
        "file" => report_file_path,
        "name" => report_name},
      account_user_id
    ]

    {:ok, session_topics_report} =
      Task.async(ResourceService, :upload, upload_params)
      |> Task.yield(upload_report_async_task, @upload_report_timeout)
      |> update_session_topics_reports_record(session_topics_reports_id)

    if File.exists?(report_file_path), do: File.rm(report_file_path)

     # TODO: front-end notification on upload (:ok, :failed)
  end


  def update_session_topics_reports_record({:ok, resource}, session_topics_reports_id) do
    session_topics_reports = Repo.get!(SessionTopicReport, session_topics_reports_id)
    session_topics_reports = Ecto.Changeset.change(session_topics_reports, status: "completed", resourceId: resource.id)

    Repo.update(session_topics_reports)
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
end
