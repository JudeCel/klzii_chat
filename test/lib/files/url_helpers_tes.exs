defmodule KlziiChat.Files.UrlHelpersTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Files.{ UrlHelpers }

  test "added base domain to link" do
    String.starts_with?(UrlHelpers.add_domain("some/link"),KlziiChat.Endpoint.url)
    |> assert
  end
end
