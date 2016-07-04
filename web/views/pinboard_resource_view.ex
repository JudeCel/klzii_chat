defmodule KlziiChat.PinboardResourceView do
  use KlziiChat.Web, :view
  alias KlziiChat.ResourceView

  def render("show.json", %{pinboard_resource: pinboard_resource}) do
    %{
      id: pinboard_resource.id,
      colour: pinboard_resource.session_member.colour,
      resource: Phoenix.View.render_one(pinboard_resource.resource, ResourceView, "resource.json")
    }
  end
end
