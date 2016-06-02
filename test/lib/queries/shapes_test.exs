defmodule KlziiChat.Services.ShapesTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.Shapes, as: QueriesShapes
  alias KlziiChat.{Repo}

  setup %{session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    Ecto.build_assoc(
      facilitator, :shapes,
      sessionId: facilitator.sessionId,
      event: %{},
      uid: "21",
      sessionTopicId: session_topic_1.id
    ) |> Repo.insert!

    Ecto.build_assoc(
      participant, :shapes,
      sessionId: facilitator.sessionId,
      event: %{},
      uid: "41",
      sessionTopicId: session_topic_1.id
    ) |> Repo.insert!

    {:ok, facilitator: facilitator, participant: participant, session_topic: session_topic_1}
  end

  test "when participant then select only own shapes for delete in session topic", %{participant: participant, session_topic: session_topic} do
    count = QueriesShapes.find_shapes_for_delete(participant, session_topic)
      |> Repo.all
      |> Enum.count
    assert(count == 1)
  end

  test "when facilitator then select all shapes for delete in session topic", %{facilitator: facilitator, session_topic: session_topic} do
    count = QueriesShapes.find_shapes_for_delete(facilitator, session_topic)
      |> Repo.all
      |> Enum.count
    assert(count == 2)
  end
end
