defmodule KlziiChat.ConsoleTest do
  use KlziiChat.ModelCase, async: true

  alias KlziiChat.Console

  @valid_attrs %{sessionTopicId: 1, audioId: 1, videoId: 2, pinboard: true, fileId: 4, miniSurveyId: 4}
  @invalid_attrs %{}

  @fields %{sessionTopicId: 1, audioId: 1, videoId: 2, pinboard: true, fileId: 4, miniSurveyId: 4}

  test "with valid attrs" do
    changeset = Console.changeset(%Console{}, @valid_attrs)
    assert(changeset.valid?)
  end

  test "with invalid attrs" do
    assert {:sessionTopicId, {"can't be blank", [validation: :required]}} in errors_on(%Console{}, %{})
  end
end
