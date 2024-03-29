defmodule KlziiChat.BannersController do
  use KlziiChat.Web, :controller
  use Guardian.Phoenix.Controller
  alias KlziiChat.Services.{BannerService}

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_account_user

  def index(conn, _, _, _) do
    banners = BannerService.all
    json(conn, %{banners: banners})
  end

  defp if_current_account_user(conn, opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      KlziiChat.Guardian.AuthErrorHandler.unauthenticated(conn, opts)
    end
 end
end
