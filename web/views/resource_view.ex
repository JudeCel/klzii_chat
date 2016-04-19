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
    case resource.type do
      "image" ->
        %{
          full: Image.url({resource.image, resource}, :thumb) |> add_domain,
          thumb: Image.url({resource.image, resource}) |> add_domain
        }
      "audio" ->
        %{
          full: Audio.url({resource.audio, resource}) |> add_domain
        }
      "video" ->
        %{
          full: Video.url({resource.video, resource}) |> add_domain
        }
      _ ->
        %{
          full: File.url({resource.file, resource}) |> add_domain
        }
    end


  end

  defp add_domain(url) do
    case Mix.env do
      :dev ->
         KlziiChat.Endpoint.url <> "/"<> Path.relative_to(url, "priv/static")
      _ ->
        url
    end
  end
end
