defmodule KlziiChat.Files.UrlHelpers do
  def add_domain(url) do
    case Mix.env do
    :dev ->
      KlziiChat.Endpoint.url <> "/"<> Path.relative_to(url, "priv/static")
      _ ->
        url
      end
  end
end
