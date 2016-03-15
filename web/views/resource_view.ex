defmodule KlziiChat.ResourceView do
  use KlziiChat.Web, :view
  alias KlziiChat.Uploaders.Image

  @spec render(String.t, Map.t) :: Map.t
  def render("resource.json", %{resource: resource}) do
    %{
      id: resource.id,
      thumb: Image.url({resource.image, resource}, :thumb) |> Path.relative_to("priv/static")
    }
  end
end
