defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller

  def index(conn, %{"token" => token}) do
    render conn, "index.html" , token: token
  end
end
