defmodule KlziiChat.Services.ReportingService do
  alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService}
  alias KlziiChat.{Repo, SessionTopicReport}

  def create_session_topic_report(session_member_id, session_topic_id, report_format, report_type, include_facilitator)
    when report_type in [:all, :star, :whiteboard] # TODO: :votes
    when report_format in [:txt, :csv, :pdf]
  do
    with {:ok, %{id: session_topics_reports_id}} <-  create_session_topics_reports_record(session_topic_id, session_member_id, report_type, include_facilitator, report_format),
         {:ok, report_name} <- get_report_name(report_type, session_topics_reports_id),
         {:ok, _}  <- Task.start(__MODULE__, :report_creator_runner, [session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator]),
     do: {:ok, session_topics_reports_id}
  end

  def create_session_topic_report(_, _, _, _, _), do: {:error, "incorrect report type of format"}

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


  def report_creator_runner(session_topics_reports_id, session_topic_id, report_name, report_format, report_type, include_facilitator) do
    star_only =
      if report_type == :star, do: true, else: false

    {:ok, report_creator_task} = Task.async(__MODULE__, :report_creator, [report_name, report_format, session_topic_id, star_only, !include_facilitator])
    result = Task.await(report_creator_task)
  end

  def report_creator(report_name, report_format, session_topic_id, star_only, exclude_facilitator) do
    {:ok, report_file_path} = SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, star_only, exclude_facilitator)
  end
end
