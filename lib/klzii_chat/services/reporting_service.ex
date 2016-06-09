alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService}
alias KlziiChat.{Repo, SessionTopicReport}

defmodule KlziiChat.Services.ReportingService do

  def create_session_topic_report(:messages, session_topic_id, session_member_id, report_format, star_only, exclude_facilitator) do
    case create_session_topics_reports_record(session_topic_id, session_member_id) do
      {:ok, %{id: session_topics_reports_id}} ->
        report_name = "Session_topic_messages_report_" <> get_random_str()
        Task.start(report_creator_runner)
        {:ok, session_topics_reports_id}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create_session_topic_report(:whiteboard, session_topic_id, :pdf) do
    report_name = "Session_topic_whiteboard_report_" <> get_random_str()
    {:ok, report_name}
  end

  def get_random_str() do
    :crypto.rand_bytes(16)
    |> Base.url_encode64(padding: false)
  end

  def create_session_topics_reports_record(session_topic_id, session_member_id) do
    Repo.insert(%SessionTopicReport{
      sessionMemberId: session_member_id,
      sessionTopicId: session_topic_id,
    })
  end

  def report_creator_runner(:messages, session_topics_reports_id, ) do
    report_creator_task = Task.async(report_creator)
    result = Task.await(report_creator_task)
  end

#  def report_creator() do
#    {:ok, report_file_path} = SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, star_only, exclude_facilitator)
#    {:ok, report_name}
#  end
end
