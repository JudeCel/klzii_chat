defmodule KlziiChat.AccountTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.Account

  test "can't update nothing" do
    changeset = Account.changeset(%Account{}, %{name: "some name"})
    assert(changeset.changes == %{})
  end
end
