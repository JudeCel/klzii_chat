defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
