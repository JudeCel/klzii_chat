defmodule KlziiChat.AuthController do
  use KlziiChat.Web, :controller
  use Guardian.Phoenix.Controller
  alias KlziiChat.Helpers.UrlHelper

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  def token(conn, _, member, _) do
    redirect_url = UrlHelper.auth_redirect_url(member.session_member.token)
    json(conn, %{redirect_url: redirect_url})
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
