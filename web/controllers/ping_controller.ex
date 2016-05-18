defmodule KlziiChat.PingController do
  use KlziiChat.Web, :controller

  def index(conn, _) do
      conn |>
      put_status(200) |>
      text("")
  end
end
