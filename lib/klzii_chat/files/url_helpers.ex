defmodule KlziiChat.Files.UrlHelpers do
  @spec add_domain(String) :: String
  def add_domain(url) do
    case Mix.env do
      :prod ->
        url
      _ ->
        add_asset_path(KlziiChat.Endpoint.url, url)
    end
  end

  @spec add_asset_path(String, String) :: String
  def add_asset_path(base_url, path) do
    base_url <> "/"<> Path.relative_to(path, "priv/static")
  end

  @spec video_service_id(String) :: {:ok} | {:error, String.t}
  def video_service_id(url) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(url)
    |> get_in(["id"])
  end

  @spec video_service_source(String) :: String.t
  def video_service_source(url) do
    if String.contains?(url, "vimeo.com") do
      "vimeo"
    else
      "youtube"
    end
  end

end
