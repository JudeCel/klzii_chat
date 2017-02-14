defmodule KlziiChat.Admin.DashboardController do
  use KlziiChat.Web, :controller

  def index(conn, _) do
    put_layout(conn, "admin.html")
    |> render("index.html")
  end
end
