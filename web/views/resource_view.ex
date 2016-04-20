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
    field = Map.get(resource, String.to_atom(resource.type))
    if field do
      Map.get(field, :file_name)
      |> Path.extname
      |> String.replace(".", "")
    end
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
          full: url_buider(resource, File, resource.file)
        }
    end
  end

  defp url_buider(resource, model, field) do
    if field do
      model.url({field, resource}) |> UrlHelpers.add_domain
    else
      ""
    end
  end
end
