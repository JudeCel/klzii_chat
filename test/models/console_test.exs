defmodule KlziiChat.ConsoleTest do
  use KlziiChat.ModelCase

  alias KlziiChat.Console
  @fields %{sessionTopicId: 1, audioId: 1, videoId: 2, imageId: 3, fileId: 4, miniSurveyId: 4}

  test "is required sessionTopicId" do
    changeset = Console.changeset(%Console{}, @fields)
    assert(changeset.required == [:sessionTopicId])
  end
  test "it allow all resource types" do
    changeset = Console.changeset(%Console{}, @fields)
    assert(changeset.changes == @fields)
  end
end
