defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.MessageService

  setup %{session_topic_1: session_topic_1, member: member} do
    # insert messages

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member.id,
      body: "test message 1",
      emotion: 1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member.id,
      body: "test message 2",
      emotion: 2
    ) |> Repo.insert!()

    {:ok, session_topic_id: session_topic_1.id, member: member}
  end

  test "convert topic history to CSV", %{member: member, session_topic_id: session_topic_id} do
    MessageService.history(session_topic_id, member)
    |> IO.inspect()
  end

end
