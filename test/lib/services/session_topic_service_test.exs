defmodule KlziiChat.Services.SessionTopicServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionTopicService
  alias Ecto.DateTime

  setup %{session_topic_1: session_topic_1, member: member, member2: member2} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

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

    {:ok, session_topic: session_topic_1, member: member, member2: member2}
  end


  test "get all sesion topic messages", %{session_topic: session_topic} do
    {:ok, messages} = SessionTopicService.message_history(session_topic.id, false, false)
    assert(Enum.count(messages) == 2)
  end

  test "get starts only topic mesages", %{session_topic: session_topic, member: member} do
    {:ok, [ %{ body: body, star: star, session_member: %{username: username} } ]}
      = SessionTopicService.message_history(session_topic.id, true, false)
    assert(body == "test message 1")
    assert(star == true)
    assert(username = member.username)
  end

  test "get topic messages excluding facilitator", %{session_topic: session_topic, member2: member2} do
    {:ok, [ %{ body: body, session_member: %{username: username, role: role} } ]}
    = SessionTopicService.message_history(session_topic.id, false, true)
    assert(body == "test message 2")
    assert(role == "participant")
    assert(username = member2.username)
  end
end
