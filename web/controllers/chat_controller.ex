defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  import KlziiChat.Services.SessionMembersService, only: [get_member_from_token: 1]

  @doc """
    This index action is only for dev or test env.
    Parameter token_dev should be Session member token
  """
  def index(conn, %{"token_dev" => token}) do
    case Mix.env do
      env when env in [:dev, :test] ->
        session_member = Repo.get_by!(KlziiChat.SessionMember, token: token)
        Guardian.Plug.sign_in(conn, session_member)
        |> render("index.html")
      _ ->
        send_resp(conn, 401, Poison.encode!(%{error: "unauthorized, allow only dev"}))
        |> halt
    end
  end

  def index(conn, %{"token" => token}) do
    case get_member_from_token(token) do
      {:ok , member} ->
        conn = Guardian.Plug.sign_in(conn, member.session_member)
        put_resp_cookie(conn, "chat_token", Guardian.Plug.current_token(conn), max_age: get_cookie_espire_time())
        |> render("index.html")
      {:error, _reason } ->
        send_resp(conn, 401, Poison.encode!(%{error: "unauthorized"}))
        |> halt
    end
  end

  def index(conn, _) do
    if chat_token = conn.cookies["chat_token"] do
      put_resp_cookie(conn, "chat_token", Guardian.Plug.current_token(conn), max_age: get_cookie_espire_time())
      |> render("index.html", token: chat_token)
    else
      send_resp(conn, 401, Poison.encode!(%{error: "unauthorized"}))
      |> halt
    end
  end

# TODO Replace with elixir standard lib when migrated to 1.3
  defp get_cookie_espire_time() do
    use Timex
    expire_date = Date.today |> Timex.shift(days: 7)
    Date.now |> Date.diff(expire_date, :seconds)
  end
end
