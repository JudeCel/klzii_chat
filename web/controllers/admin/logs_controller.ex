defmodule KlziiChat.Admin.LogsController do
  use KlziiChat.Web, :controller
  alias KlziiChat.Services.ConnectionLogService

  def index(conn, params) do
    put_layout(conn, "admin.html")
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    case ConnectionLogService.get(id) do
      {:ok, connection_log} ->
        put_layout(conn, "admin.html")
        |> render("show.html", connection_log: connection_log)
      {:error, resaon} ->
        put_layout(conn, "admin.html")
        |> render("show.html", log: %{})
    end
  end
end
