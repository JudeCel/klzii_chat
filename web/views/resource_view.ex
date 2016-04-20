defmodule KlziiChat.ResourceView do
  use KlziiChat.Web, :view
  alias KlziiChat.Uploaders.{Image, Audio, Video}
  alias KlziiChat.Files.{ UrlHelpers }

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
    |> String.replace(".", "")
  end

  defp getUrl(resource) do
    case resource.type do
      "image" ->
        %{
          thumb: Image.url({resource.image, resource}, :thumb) |> UrlHelpers.add_domain,
          full: Image.url({resource.image, resource}) |> UrlHelpers.add_domain
        }
      "audio" ->
        %{
          full: Audio.url({resource.audio, resource}) |> UrlHelpers.add_domain
        }
      "video" ->
        %{
          full: Video.url({resource.video, resource}) |> UrlHelpers.add_domain
        }
      _ ->
        %{
          full: File.url({resource.file, resource}) |> UrlHelpers.add_domain
        }
    end
  end
end
