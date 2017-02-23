defmodule KlziiChat.Admin.Monitoring.MonitoringController do
  use KlziiChat.Web, :controller
  alias KlziiChat.Services.ConnectionLogService

  def index(conn, _) do
    put_layout(conn, "admin.html")
    |> render("index.html")
  end
end
