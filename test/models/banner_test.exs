defmodule KlziiChat.BannerTest do
  use KlziiChat.ModelCase

  alias KlziiChat.Banner
  @fields %{page: "string", link: "string"}

  test "can't update nothing" do
    changeset = Banner.changeset(%Banner{}, @fields)
    assert(changeset.changes == %{})
  end
end
