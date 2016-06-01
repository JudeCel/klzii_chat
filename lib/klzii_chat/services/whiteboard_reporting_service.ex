defmodule KlziiChat.Services.WhiteboardReportingService do
  alias KlziiChat.Services.WhiteboardService

    def save_report(path_to_file, :pdf, session_topic_id) do
      WhiteboardService.history(session_topic_id)
    end
end
