defmodule KlziiChat.DirectMessageTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.DirectMessage

  @valid_attrs %{sessionId: 1, senderId: 2, recieverId: 3, text: "test", readAt: Timex.DateTime.now }
  @invalid_attrs %{}


  test "with valid attrs" do
    changeset = DirectMessage.changeset(%DirectMessage{}, @valid_attrs)
    assert(changeset.valid?)
    assert(changeset.changes == @valid_attrs)
  end

  test "with invalid attrs" do
    assert {:text, {"can't be blank", []}} in errors_on(%DirectMessage{}, %{})
    assert {:sessionId, {"can't be blank", []}} in errors_on(%DirectMessage{}, %{})
    assert {:senderId, {"can't be blank", []}} in errors_on(%DirectMessage{}, %{})
    assert {:recieverId, {"can't be blank", []}} in errors_on(%DirectMessage{}, %{})
  end
end
