defmodule KlziiChat.SessionResourcesView do
  use KlziiChat.Web, :view
  alias KlziiChat.ResourceView

  def render("show.json", %{session_resource: session_resource})do
    %{id: session_resource.id,
      resource: Phoenix.View.render_one(session_resource.resource, ResourceView, "resource.json")
    }
  end

  def render("delete.json", %{session_resource: session_resource})do
    %{id: session_resource.id,
      type: session_resource.resource.type
    }
  end
end
