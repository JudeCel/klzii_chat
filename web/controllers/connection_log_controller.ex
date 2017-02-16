defmodule KlziiChat.ConnectionLogController do
  use KlziiChat.Web, :controller
  alias KlziiChat.Services.ConnectionLogService

  def index(conn, params) do
    ConnectionLogService.save(params)
    send_resp(conn, 200, "")
  end
end
