defmodule KlziiChat.ResourceView do
  use KlziiChat.Web, :view

  @spec render(String.t, Map.t) :: Map.t
  def render("resource.json", %{resource: resource}) do
    %{
      id: resource.id,
      URL: Map.get(resource, "URL")
    }
  end
end
