defmodule KlziiChat.Services.WhiteboardReportingService do
  alias KlziiChat.{Repo, Shape}
  alias KlziiChat.Helpers.HTMLWhiteboardReportHelper
  alias KlziiChat.Services.FileService

  import Ecto.Query, only: [from: 2]

  @tmp_path Path.expand("/tmp/klzii_chat/reporting")

  @spec save_report(String.t, :pdf, integer) :: {:ok | :error, String.t}
  def save_report(report_name, :pdf, session_topic_id) do
    wb_events = get_all_events(session_topic_id)
    html_text = HTMLWhiteboardReportHelper.html_from_template(%{wb_events: wb_events})

    html_file_path = FileService.compose_path(@tmp_path, report_name, "html")
    :ok = FileService.write_data(html_file_path, html_text)
    FileService.html_to_pdf(html_file_path)
  end

  @spec get_all_events(integer) :: Map
  def get_all_events(session_topic_id) do
    Repo.all(
      from shape in Shape,
      where: shape.sessionTopicId == ^session_topic_id,
      order_by: [asc: shape.updatedAt],
      select: shape.event
    )
  end
end
