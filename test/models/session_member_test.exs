defmodule KlziiChat.SessionMemberTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.SessionMember

  @valid_attrs %{username: "user name", avatarData: %{}, sessionTopicContext: %{"1" => ""}}

  test "with valid attrs" do
    changeset = SessionMember.changeset(%SessionMember{}, @valid_attrs)
    assert(changeset.valid?)
    assert(changeset.changes == @valid_attrs)
  end

  test "with invalid attrs" do
    assert({:username, {"can't be blank", [validation: :required]}} in errors_on(%SessionMember{}, %{username: " "}))
  end
end
