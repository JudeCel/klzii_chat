defmodule KlziiChat.Tasks.ReportController do
  use KlziiChat.Web, :controller
  alias KlziiChat.Services.SessionReportingService

  def index(conn, _) do
    put_layout(conn, "tasks.html")
    |> render("index.html")
  end

  def delete_all_report(conn, _) do
    {count, _} = SessionReportingService.delete_all()
    put_layout(conn, "tasks.html")
    |> render("delete_all_report.html", count: count)
  end
end
