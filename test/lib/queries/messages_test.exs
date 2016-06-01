defmodule KlziiChat.Services.SessionTopicServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionTopicService
  alias Ecto.DateTime

  setup %{session: session, session_topic_1: session_topic_1, member: member, member2: member2} do
    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member.id,
      body: "test message 1",
      emotion: 0,
      star: true,
      createdAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: member2.id,
      body: "test message 2",
      emotion: 1,
      star: false,
      createdAt: create_date2
    ) |> Repo.insert!()

    {:ok, session_topic: session_topic_1, member: member, member2: member2, create_date1: create_date1, create_date2: create_date2}
  end

  test "base query - all messages", %{session_topic: session_topic} do

  end

end
