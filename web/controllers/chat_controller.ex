defmodule KlziiChat.ChatController do
  use KlziiChat.Web, :controller
  import KlziiChat.Services.SessionMembersService, only: [get_member_from_token: 1]

  @doc """
    This index action is only for dev or test env.
    Parameter token dev should be Session member token
  """
  def index(conn, %{"token_dev" => token}) do
    case Mix.env do
      env when env in [:dev, :test] ->
        session_member = Repo.get_by!(KlziiChat.SessionMember, token: token)
        Guardian.Plug.sign_in(conn, session_member)
        |> render("index.html")
      true ->
        send_resp(conn, 401, Poison.encode!(%{error: "unauthorized, allow only dev"}))
        |> halt
    end
  end

  def index(conn, %{"token" => token}) do
    if chat_token = get_session(conn, :chat_token) do
      render conn, "index.html" , token: chat_token
    else
      case get_member_from_token(token) do
        {:ok , member} ->
          Guardian.Plug.sign_in(conn, member.session_member)
          |> render("index.html")
        {:error, _reason } ->
          send_resp(conn, 401, Poison.encode!(%{error: "unauthorized"}))
          |> halt
      end
    end
  end
end
