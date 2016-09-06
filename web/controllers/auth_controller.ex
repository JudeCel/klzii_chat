defmodule KlziiChat.AuthController do
  use KlziiChat.Web, :controller
  use Guardian.Phoenix.Controller
  import KlziiChat.ErrorHelpers, only: [error_view: 1]
  alias KlziiChat.Helpers.UrlHelper
  alias KlziiChat.Services.Permissions.Session, as: SessionPermissions

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_member

  def token(conn, _, member, claims) do
    session_member = Repo.get_by!(KlziiChat.SessionMember, id: member.session_member.id)
    session = Repo.get_by!(KlziiChat.Session, id: member.session_member.sessionId)

    case SessionPermissions.can_access?(member.account_user, session_member, session) do
      {:ok} ->
        {:ok, %{"callback_url" => callback_url}} = claims
        { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(member.session_member, :token, %{callback_url: callback_url} )
        redirect_url = UrlHelper.auth_redirect_url(jwt) |> to_string
        json(conn, %{redirect_url: redirect_url})
      {:error, reason} ->
        put_status(conn, reason.code)
          |> json(error_view(reason))
    end
  end

  defp if_current_member(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
  end
end
