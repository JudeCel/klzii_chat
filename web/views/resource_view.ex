defmodule KlziiChat.ResourceView do
  use KlziiChat.Web, :view
  alias KlziiChat.Uploaders.{Image, Audio, Video}

  @spec render(String.t, Map.t) :: Map.t
  def render("resource.json", %{resource: resource}) do
    %{
      id: resource.id,
      type: resource.type,
      url: getUrl(resource),
      name: resource.name,
      extension: extension(resource)
    }
  end

  def extension(resource) do
    Map.get(resource, String.to_atom(resource.type))
    |> Map.get(:file_name)
    |> Path.extname
  end

  defp getUrl(resource) do
    url = case resource.type do
      "image" ->
        Image.url({resource.image, resource}, :thumb)
      "audio" ->
        Audio.url({resource.audio, resource})
      "video" ->
        Video.url({resource.video, resource})
    end

    Path.relative_to(url, "priv/static")
  end
end
