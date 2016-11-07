defmodule KlziiChat.Tasks.ReportController do
  use KlziiChat.Web, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
