defmodule KlziiChat.Services.WhiteboardReportingService do
  alias KlziiChat.{Repo, Shape}
  alias KlziiChat.Helpers.HTMLWhiteboardReportHelper
  alias KlziiChat.Services.FileService

  import Ecto.Query, only: [from: 2]

  @spec save_report(String.t, :pdf, integer) :: {:ok | :error, String.t}
  def save_report(report_name, :pdf, session_topic_id) do
    wb_events = get_all_events(session_topic_id)
    html_text = HTMLWhiteboardReportHelper.html_from_template(%{wb_events: wb_events})

    {:ok, html_file_path} = FileService.write_report(report_name, :pdf, html_text)
    {:ok, html_file_path}
  end

  @spec get_all_events(integer) :: List.t
  def get_all_events(session_topic_id) do
    Repo.all(
      from shape in Shape,
      where: shape.sessionTopicId == ^session_topic_id,
      order_by: [asc: shape.updatedAt],
      select: shape.event
    )
  end
end
