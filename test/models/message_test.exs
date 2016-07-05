defmodule KlziiChat.MessageTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.Message

  @valid_attrs %{sessionTopicId: 1, sessionMemberId: 2, body: "test", emotion: 1 }
  @invalid_attrs %{}


  test "with valid attrs" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert(changeset.valid?)
    assert(changeset.changes == @valid_attrs)
  end

  test "with invalid attrs" do
    assert {:body, {"can't be blank", []}} in errors_on(%Message{}, %{})
    assert({:body, {"should be at least %{count} character(s)", [count: 1]}} in errors_on(%Message{}, %{body: ""}))
    assert {:sessionTopicId, {"can't be blank", []}} in errors_on(%Message{}, %{})
    assert {:sessionMemberId, {"can't be blank", []}} in errors_on(%Message{}, %{})
  end

  test "error rendering" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    KlziiChat.ChangesetView.render("error.json", %{changeset: changeset})
    |> IO.inspect
  end
end
