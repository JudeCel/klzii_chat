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

  @spec youtube_id(String) :: String
  def youtube_id(url) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(url)
    |> get_in(["id"])
  end
end
