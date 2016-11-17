defmodule KlziiChat.ResourceView do
  use KlziiChat.Web, :view
  alias KlziiChat.Uploaders.{Image, Audio, Video, File}
  alias KlziiChat.Files.{ UrlHelpers }
  alias KlziiChat.ResourceView

  @spec render(String.t, Map.t) :: Map.t
  def render("resource.json", %{resource: resource}) do
    %{
      id: resource.id,
      type: resource.type,
      url: getUrl(resource),
      name: resource.name,
      extension: extension(resource),
      scope: resource.scope,
      stock: resource.stock,
      static: false,
      session_statuses: session_statuses(resource.session_resources),
    }
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("resources.json", %{data: data}) do
    %{
      pages: data.pages,
      resources: Phoenix.View.render_many(data.resources, ResourceView, "resource.json", as: :resource)
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
    if is_map(field) do
      Map.get(field, :file_name)
      |> Path.extname
      |> String.replace(".", "")
    end
  end

  defp getUrl(resource) do
    case resource.type do
      "image" ->
        %{
          thumb: url_builder(resource, Image,  Map.get(resource, :image), :thumb ),
          full: url_builder(resource, Image,  Map.get(resource, :image), :original),
          gallery_thumb: url_builder(resource, Image,  Map.get(resource, :image), :gallery_thumb)
        }
      "link" ->
        %{
          full: resource.link
        }
      "audio" ->
        %{
          full: url_builder(resource, Audio,  Map.get(resource, :audio), :original)
        }
      "video" ->
        %{
          full: url_builder(resource, Video,  Map.get(resource, :video), :original)
        }
      _ ->
        %{
          full: url_builder(resource, File,  Map.get(resource, :file, nil), :original )
        }
    end
  end

  defp url_builder(resource, model, field, version) do
    if field do
      model.url({field, resource}, version) |> UrlHelpers.add_domain
    else
      ""
    end
  end

  defp session_statuses(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp session_statuses(session_statuses), do: session_statuses
end
