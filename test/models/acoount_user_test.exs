defmodule KlziiChat.AccountUserTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.AccountUser

  @fields %{
    UserId: 1,
    AccountId: 2,
    firstName: "firstName",
    lastName: "lastName",
    gender: "gender",
    role: "role",
    email: "email",
  }

  test "can't update nothing" do
    changeset = AccountUser.changeset(%AccountUser{}, @fields)
    assert(changeset.changes == %{})
  end
end
