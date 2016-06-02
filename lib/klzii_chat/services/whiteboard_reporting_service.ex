defmodule KlziiChat.Services.WhiteboardReportingService do
  alias KlziiChat.{Repo, Shape}
  alias KlziiChat.Helpers.HTMLWhiteboardReportHelper
  alias KlziiChat.Services.FileService

  import Ecto.Query, only: [from: 2]

    def save_report(path_to_file, :pdf, session_topic_id) do
      wb_events = get_all_events(session_topic_id)

      html_text = HTMLWhiteboardReportHelper.html_from_template(%{wb_events: wb_events})
      :ok = FileService.write_data(path_to_file, html_text)
    end

    def get_all_events(session_topic_id) do
      Repo.all(
        from shape in Shape,
        where: shape.sessionTopicId == ^session_topic_id,
        order_by: [asc: shape.updatedAt],
        select: shape.event
      )
    end
end
