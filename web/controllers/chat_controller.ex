defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  # import KlziiChat.ErrorHelpers, only: [error_view: 1]
  import KlziiChat.Services.SessionMembersService, only: [get_member_from_token: 1]
    alias KlziiChat.{SessionMember, Repo}

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
        {:ok, member, _} ->
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

  def logout(conn, %{"token" => token}) do
    if conn.cookies["redirect_url"] != nil do
      case get_member_from_token(token) do
        {:ok, member, _} ->
          IO.inspect(member.session_member)
          if member.session_member.role == "facilitator" do
            redirect(conn, external: conn.cookies["redirect_url"])
          else
            sessionsCount = from(st in SessionMember, where: st.accountUserId == ^member.session_member.accountUserId, select: count("*")) |> Repo.one
            if sessionsCount > 1 do
              redirect(conn, external: conn.cookies["redirect_url"])
            else
              logout_all(conn, nil)
            end
          end
        {:error, _} ->
          logout_message(conn)
      end
    else
      logout_message(conn)
    end
  end

  def logout_all(conn, _) do
    if conn.cookies["redirect_url"] != nil do
      url = conn.cookies["redirect_url"] |> URI.parse |> Map.put(:path, "/logout") |> Map.put(:fragment, nil) |> Map.put(:query, nil) |> URI.to_string
      redirect(conn, external: url)
    else
      logout_message(conn)
    end
  end

  def logout_message(conn) do
    send_resp(conn, 200, "You are logged out")
  end

  defp set_redirect_url(conn, nil), do: conn
  defp set_redirect_url(conn, callback_url) do
    put_resp_cookie(conn, "redirect_url", callback_url)
  end


  defp get_cookie_espire_time() do
    use Timex
    expire_date = Timex.now |> Timex.shift(days: 7)
    Timex.now |> Timex.diff(expire_date, :seconds)
  end
end
