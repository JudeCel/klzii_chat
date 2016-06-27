defmodule KlziiChat.VoteTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.Vote

  @valid_attrs %{messageId: 1, sessionMemberId: 2}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vote.changeset(%Vote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vote.changeset(%Vote{}, @invalid_attrs)
    refute changeset.valid?
  end
end
