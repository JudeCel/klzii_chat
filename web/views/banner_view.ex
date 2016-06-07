defmodule KlziiChat.BannerView do
  use KlziiChat.Web, :view
  alias KlziiChat.{ ResourceView }

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{banner: banner}) do
    %{
      id: banner.id,
      page: banner.page,
      link: banner.link,
      resource: render_one(banner.resource, ResourceView, "resource.json")
    }
  end
end
