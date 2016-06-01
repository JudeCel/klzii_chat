defmodule KlziiChat.Guardian.AuthErrorHandler do
  import Plug.Conn

  def unauthenticated(conn, _) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Poison.encode!(%{error: "unauthorized"}))
    |> halt
  end
end
