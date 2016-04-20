defmodule KlziiChat.Files.UrlHelpers do
  @spec add_domain(String.t) :: String.t
  def add_domain(url) do
    case Mix.env do
      :prod ->
        url
      _ ->
        KlziiChat.Endpoint.url <> "/"<> Path.relative_to(url, "priv/static")
    end
  end

  def youtube_id(url) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(url)
    |> get_in(["id"])
  end
end
