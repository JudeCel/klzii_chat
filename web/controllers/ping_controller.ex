defmodule KlziiChat.PingController do
  use KlziiChat.Web, :controller

  def index(conn, _) do
      conn |>
      put_status(200) |>
      text("")
  end

  def info(conn, params) do
    IO.inspect(params)
    send_resp(conn, 200, Poison.encode!(params))
  end
end
