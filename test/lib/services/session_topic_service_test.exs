defmodule KlziiChat.Services.SessionTopicServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionTopicService

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 0,
      star: true,
      createdAt: create_date1,
      updatedAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 1,
      star: false,
      createdAt: create_date2,
      updatedAt: create_date2
    ) |> Repo.insert!()

    {:ok, session_topic_id: session_topic_1.id, participant: participant, create_date1: create_date1,
      create_date2: create_date2, session_name: session.name, session_topic_name: session_topic_1.name}
  end

  test "get all messages", %{session_topic_id: session_topic_id, create_date1: create_date1, create_date2: create_date2} do
    [message1, message2] = SessionTopicService.get_messages(session_topic_id, false, true)

    assert(message1.createdAt == create_date1)
    assert(message2.createdAt == create_date2)
  end

  test "get star only messages", %{session_topic_id: session_topic_id} do
    [%{star: true}] = SessionTopicService.get_messages(session_topic_id, true, true)
  end

  test "get messages exluding facilitator", %{session_topic_id: session_topic_id} do
    [%{session_member: %{role: "participant"}}] = SessionTopicService.get_messages(session_topic_id, false, false)
  end

  test "get [] for star only messages exluding facilitator", %{session_topic_id: session_topic_id} do
    [] = SessionTopicService.get_messages(session_topic_id, true, false)
  end

  test "get session and session topic names", %{session_topic_id: session_topic_id, session_name: session_name,
    session_topic_name: session_topic_name} do

    %{name: ^session_topic_name, session: %{name: ^session_name}} = SessionTopicService.get_session_topic_wsession(session_topic_id)
  end

  test "#SessionTopicService - facilitator can update board message ", %{facilitator: facilitator, session_topic_1: session_topic_1} do
    message = " jeee"
    {:ok, session_topic} = SessionTopicService.board_message(facilitator.id, session_topic_1.id, %{"message" => message})
    assert(message == session_topic.boardMessage)
  end

  test "#SessionTopicService - participent can't update board message ", %{participant: participant, session_topic_1: session_topic_1} do
    message = " jeee"
    {:error, %{permissions: error_message}} = SessionTopicService.board_message(participant.id, session_topic_1.id, %{"message" => message})
    assert(error_message == SessionTopicService.errors_messages.action_not_allowed)
  end
end
