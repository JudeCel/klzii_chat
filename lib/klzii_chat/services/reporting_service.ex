alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService}


defmodule KlziiChat.Services.ReportingService do

  def create_session_topic_report(:messages, session_topic_id, report_format, star_only, exclude_facilitator) do
    report_name = "Session_topic_messages_report_" <> get_random_str()
    {:ok, report_file_path} = SessionTopicReportingService.save_report(report_name, report_format, session_topic_id, star_only, exclude_facilitator)
    {:ok, report_name}
  end

  def create_session_topic_report(:whiteboard, session_topic_id, :pdf) do
    report_name = "Session_topic_whiteboard_report_" <> get_random_str()
    {:ok, report_name}
  end

  def get_random_str() do
    :crypto.rand_bytes(16)
    |> Base.url_encode64(padding: false)
  end
end
