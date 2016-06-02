defmodule KlziiChat.Services.WhiteboardReportingService do
  alias KlziiChat.Services.{WhiteboardService, FileService}
  alias KlziiChat.Helpers.HTMLWhiteboardReportHelper

    def save_report(path_to_file, :pdf, session_topic_id, session_member_id) do
      {:ok, wb_history} = WhiteboardService.history(session_topic_id, session_member_id)
      wb_elements = Enum.map(wb_history, &elements_filer(&1))

      html_text = HTMLWhiteboardReportHelper.html_from_template(%{elements: wb_elements})
      :ok = FileService.write_data(path_to_file, html_text)
    end

    def elements_filer(%{event: %{"element" => %{"attr" => attr, "type" => type}}}), do: Map.put(attr, "type", type)
end
