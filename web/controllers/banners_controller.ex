defmodule KlziiChat.BannersController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Banner, Repo, BannerView}
  use Guardian.Phoenix.Controller
  alias KlziiChat.Services.{BannerService}

  plug Guardian.Plug.EnsureAuthenticated, handler: KlziiChat.Guardian.AuthErrorHandler
  plug :if_current_account_user

  def index(conn, params, account_user, claims) do
    banners = BannerService.all
    json(conn, %{banners: banners})
  end
end
