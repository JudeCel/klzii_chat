alias KlziiChat.Services.{SessionTopicReportingService, SessionTopicService}

defmodule KlziiChat.Services.ReportingService do
  @date_time_format "{YYYY}_{0M}_{0D}_{h24}_{0m}"

  def create_st_message_report(session_topic_id, report_format, star_only, exclude_facilitator) do
    report_name = get_report_name("Session_topic_messages_report", session_topic_id, Timex.DateTime.local())
    SessionTopicReportingService.save_report
  end

  def create_st_whiteboard_report(session_topic_id) do
  end

  def get_report_name(report_name_prefix, session_topic_id, datetime) do
    {session_name, session_topic_name} = SessionTopicService.get_session_and_topic_names(session_topic_id)
    {:ok, date_time_str} = Timex.format(datetime, @date_time_format)
    "#{report_name_prefix}_#{remove_non_alph_chars(session_name)}_#{remove_non_alph_chars(session_topic_name)}_#{date_time_str}"
  end

  def remove_non_alph_chars(string), do: String.replace(string, ~r/\P{L}/, "")
end
