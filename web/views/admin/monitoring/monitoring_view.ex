defmodule KlziiChat.Admin.Monitoring.MonitoringView do
  use KlziiChat.Web, :view

  def current_link(conn, path) do
    if (path == conn.request_path) do
      "active"
    else
      ""
    end
  end
end
