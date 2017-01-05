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
      source: resource.source,
      static: false
    }
  end
  def render("resources.json", %{data: data}) do
    %{
      pages: data.pages,
      resources: Phoenix.View.render_many(data.resources, ResourceView, "resource.json", as: :resource)
    }
  end
  def render("delete_check.json", %{used_in_closed_session: used_in_closed_session}) do
    names = get_names(used_in_closed_session)
    message = Enum.join(["Selected files:", names, "are used in Closed Session. Do you still want to Delete them?"], " ")
    %{
      used_in_closed_session: ResourceView.render("delete_items.json", %{data: used_in_closed_session, message: message}),
    }
  end
  def render("delete.json", %{removed: removed, not_removed_stock: not_removed_stock, not_removed_used: not_removed_used}) do
    not_removed_stock_names = get_names(not_removed_stock)
    not_removed_used_names = get_names(not_removed_used)
    not_removed_stock_message = Enum.join(["Sorry, we cannot Delete the following because they are Stock files:", not_removed_stock_names], " ")
    not_removed_used_message = Enum.join(["Sorry, we cannot delete the following files as they are currently used in a Chat Session or Mail Templates:", not_removed_used_names], " ")
    %{
      removed: ResourceView.render("delete_items.json", %{data: removed, message: "Your selected files were successfully deleted"}),
      not_removed_stock: ResourceView.render("delete_items.json", %{data: not_removed_stock, message: not_removed_stock_message}),
      not_removed_used: ResourceView.render("delete_items.json", %{data: not_removed_used, message: not_removed_used_message})
    }
  end
  def render("delete_items.json", %{data: data, message: message}) do
    %{
      message: message,
      items: Phoenix.View.render_many(data, ResourceView, "delete_item.json", as: :resource)
    }
  end
  def render("delete_item.json", %{resource: resource}) do
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

  defp get_names(items) do
    Enum.reduce(items, "", fn (map, acc) ->
      if acc == "" do
        map.name
      else
       acc <> ", " <> map.name
      end
    end)
  end
end
