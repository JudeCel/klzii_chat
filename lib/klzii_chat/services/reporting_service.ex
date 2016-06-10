defmodule KlziiChat.Services.ReportingService do
  alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService}
  alias KlziiChat.{Repo, SessionTopicReport}

  @save_report_timeout 10000

  def create_session_topic_report(session_member_id, session_topic_id, report_format, report_type, include_facilitator)
    when report_type in [:all, :star, :whiteboard] and report_format in [:txt, :csv, :pdf]    # TODO: :votes
  do
    with {:ok, %{id: session_topics_reports_id}} <-  create_session_topics_reports_record(session_topic_id, session_member_id, report_type, include_facilitator, report_format),
         {:ok, report_name} <- get_report_name(report_type, session_topics_reports_id),
         {:ok, _}  <- Task.start(__MODULE__, :process_report_asyc, [session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator]),
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

  def create_session_topics_reports_record(_, _, :whiteboard, _, _) do
    {:error, "only pdf format is acceptable for whiteboard report"}
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

  def update_session_topics_reports_record(:ok, session_topics_reports_id, report_file_path) do
  end

  def update_session_topics_reports_record(:error, err) do
    Repo.update()
  end

  def get_report_name(:whiteboard, session_topics_reports_id), do: {:ok, "Session_topic_whiteboard_report_" <> to_string(session_topics_reports_id)}
  def get_report_name(report_type, session_topics_reports_id), do: {:ok, "Session_topic_messages_report_" <> to_string(session_topics_reports_id)}

  def process_report_asyc(session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator) do
    star_only = if report_type == :star, do: true, else: false

    save_report_async_task = Task.async(__MODULE__, :creator, [report_name, report_format, session_topic_id, star_only, !include_facilitator])
    case Task.yield(save_report_async_task, @save_report_timeout) do
      {:ok, report_file_path} -> update_session_topics_reports_record(:ok, session_topics_reports_id, report_file_path)
      {:exit, err} -> update_session_topics_reports_record(:error, err)
      nil ->  update_session_topics_reports_record(:error, "Report ceate timeout")
    end
  end

  def save_report_async(report_name, report_format, session_topic_id, star_only, exclude_facilitator) do
    {:ok, report_file_path} = SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, star_only, exclude_facilitator)
  end
end
