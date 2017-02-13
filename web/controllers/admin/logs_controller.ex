defmodule KlziiChat.Admin.LogsController do
  use KlziiChat.Web, :controller

  def index(conn, params) do
    put_layout(conn, "admin.html")
    |> render("index.html")
  end
end
