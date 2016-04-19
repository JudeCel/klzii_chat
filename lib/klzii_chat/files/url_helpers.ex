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
end
