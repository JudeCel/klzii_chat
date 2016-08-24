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

  @spec youtube_id(String) :: {:ok} | {:error, String.t}
  def youtube_id(url) do
    case youtube_url_validator(url) do
      {:ok} ->
        result = ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
        |> Regex.named_captures(url)
        |> get_in(["id"])
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec youtube_url_validator(String) :: {:ok} | {:error, String.t}
  def youtube_url_validator(url) do
    valid_paterns = ~r{(youtu.be/|youtube.com/embed|youtube.com/watch|youtube.com/v/|youtube.com)}
    if String.match?(url, valid_paterns) do
      {:ok}
    else
      {:error, "link not valid"}
    end
  end
end
