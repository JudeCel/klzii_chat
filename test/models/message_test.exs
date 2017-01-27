defmodule KlziiChat.MessageTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.Message

  @valid_attrs %{sessionTopicId: 1, sessionMemberId: 2, body: "test", emotion: 1 }

  test "with valid attrs" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert(changeset.valid?)
    assert(changeset.changes == @valid_attrs)
  end

  test "with invalid attrs" do
    assert {:body, {"can't be blank", [validation: :required]}} in errors_on(%Message{}, %{})
    assert {:sessionTopicId, {"can't be blank", [validation: :required]}} in errors_on(%Message{}, %{})
    assert {:sessionMemberId, {"can't be blank", [validation: :required]}} in errors_on(%Message{}, %{})
  end
end
