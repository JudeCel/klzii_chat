defmodule KlziiChat.SessionTopicTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.SessionTopic

  @valid_attrs %{boardMessage: "some content"}

  test "changeset with valid attributes" do
    changeset = SessionTopic.changeset(%SessionTopic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "can update only boardMessage" do
    changeset = SessionTopic.changeset(%SessionTopic{}, %{boardMessage: "jjee"})
    assert(changeset.errors == [])
    assert(changeset.changes == %{boardMessage: "jjee", board_message_text: "jjee"})
  end
end
