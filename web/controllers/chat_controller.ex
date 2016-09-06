defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  # import KlziiChat.ErrorHelpers, only: [error_view: 1]
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
        |> render("index.html", session_id: session_member.sessionId)
      _ ->
        send_resp(conn, 401, Poison.encode!(%{error: "unauthorized, allow only dev"}))
    end
  end

  def index(conn, %{"token" => token}) do
    case get_member_from_token(token) do
      {:ok, member, callback_url} ->
        conn = set_redirect_url(conn, callback_url)
        |> Guardian.Plug.sign_in(member.session_member)
        put_resp_cookie(conn, "chat_token", Guardian.Plug.current_token(conn), max_age: get_cookie_espire_time())
        |> render("index.html", session_id: member.session_member.sessionId)
      {:error, _reason } ->
        resp =  KlziiChat.ChangesetView.render("error.json", %{not_found: "Session member not found"})
          |> Poison.encode!
        send_resp(conn, 401, resp)
    end
  end

  def index(conn, _) do
    if chat_token = conn.cookies["chat_token"] do
      case get_member_from_token(chat_token) do
        {:ok ,member, _} ->
          conn = Guardian.Plug.sign_in(conn, member.session_member)
          put_resp_cookie(conn, "chat_token", Guardian.Plug.current_token(conn), max_age: get_cookie_espire_time())
          |> render("index.html", session_id: member.session_member.sessionId)
        {:error, _reason } ->
          resp =  KlziiChat.ChangesetView.render("error.json", %{not_found: "Session member not found"})
            |> Poison.encode!
          send_resp(conn, 401, resp)
      end
    else
      resp =  KlziiChat.ChangesetView.render("error.json", %{not_found: "Session member not found or you need login"})
        |> Poison.encode!
      send_resp(conn, 401, resp)
    end
  end

  def logout(conn, _) do
    conn = Guardian.Plug.sign_out(conn)
    |> delete_resp_cookie("chat_token")

    if redirect_url = conn.cookies["redirect_url"] do
      delete_resp_cookie(conn, "redirect_url")
      |> redirect(external: redirect_url)
    else
      send_resp(conn, 200, Poison.encode!(%{message: "Successfully logged out"}))
    end
  end

  defp set_redirect_url(conn, callback_url) do
    put_resp_cookie(conn, "redirect_url", callback_url)
  end

  defp get_cookie_espire_time() do
    use Timex
    expire_date = Timex.now |> Timex.shift(days: 7)
    Timex.now |> Timex.diff(expire_date, :seconds)
  end
end
