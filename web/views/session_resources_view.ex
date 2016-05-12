defmodule KlziiChat.SessionResourcesView do
  use KlziiChat.Web, :view
  alias KlziiChat.ResourceView

  def render("show.json", %{session_resource: session_resource})do
    %{id: session_resource.resourceId,
      resource: Phoenix.View.render_one(session_resource.resource, ResourceView, "resource.json")
    }
  end
end
