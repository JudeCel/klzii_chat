defmodule KlziiChat.AuthController do
  use KlziiChat.Web, :controller
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  def token(conn, _, member, _) do
    token = member.session_member.token
    json(conn, %{redirect_url: build_redirect_url(token)})
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end

 defp build_redirect_url(token) do
   KlziiChat.Router.Helpers.chat_url(KlziiChat.Endpoint, :index, token: token)
 end
end
