defmodule KlziiChat.ConnectionLogController do
  use KlziiChat.Web, :controller

  def index(conn, params) do
    IO.inspect params
    send_resp(conn, 200, "")
  end
end
