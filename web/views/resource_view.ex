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

  @spec render(String.t, Map.t) :: Map.t
  def render("delete.json", %{resource: resource}) do
    %{
      id: resource.id
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
          thumb: url_buider(resource, Image,  Map.get(resource, :image), :thumb ),
          full: url_buider(resource, Image,  Map.get(resource, :image))
        }
      "audio" ->
        %{
          full: url_buider(resource, Audio,  Map.get(resource, :audio))
        }
      "video" ->
        %{
          full: url_buider(resource, Video,  Map.get(resource, :video))
        }
      _ ->
        %{
          full: url_buider(resource, File,  Map.get(resource, :file, nil) )
        }
    end
  end

  defp url_buider(resource, model, field, version \\ :orginal) do
    if field do
      model.url({field, resource}, version) |> UrlHelpers.add_domain
    else
      ""
    end
  end
end
