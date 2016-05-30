defmodule KlziiChat.Helpers.UrlHelperTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Helpers.UrlHelper

  test "return url with token" do
    token = "some_string"
    UrlHelper.auth_redirect_url(token)
    |> String.contains?(token)
    |> assert
  end
end
