defmodule KlziiChat.BrandProjectPreferenceTest do
  use KlziiChat.ModelCase

  alias KlziiChat.BrandProjectPreference

  @fields %{name: "string", colours: %{}, accountId: 1}

  test "can't update nothing" do
    changeset = BrandProjectPreference.changeset(%BrandProjectPreference{}, @fields)
    assert(changeset.changes == %{})
  end
end
