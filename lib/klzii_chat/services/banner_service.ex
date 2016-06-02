defmodule KlziiChat.Services.BannerService do
  alias KlziiChat.{Repo, Banner, BannerView}
  import Ecto.Query, only: [from: 2]

  def all do
    from(b in Banner, preload: :resource)
    |> Repo.all
    |> Phoenix.View.render_many(BannerView, "show.json")
  end
end
