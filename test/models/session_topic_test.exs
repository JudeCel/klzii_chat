defmodule KlziiChat.SessionTopicTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.SessionTopic

  @valid_attrs %{boardMessage: "some content"}
  @invalid_attrs %{boardMessage: ""}

  test "changeset with valid attributes" do
    changeset = SessionTopic.changeset(%SessionTopic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SessionTopic.changeset(%SessionTopic{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "can update only boardMessage" do
    changeset = SessionTopic.changeset(%SessionTopic{}, %{boardMessage: "jjee"})
    assert(changeset.required == [:boardMessage])
  end
end
