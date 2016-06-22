defmodule KlziiChat.Services.SessionTopicServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.SessionTopicService

  test "#SessionTopicService - facilitator can update board message ", %{facilitator: facilitator, session_topic_1: session_topic_1} do
    message = " jeee"
    {:ok, session_topic} = SessionTopicService.board_message(facilitator.id, session_topic_1.id, %{"message" => message})
    assert(message == session_topic.boardMessage)
  end

  test "#SessionTopicService - participent can't update board message ", %{participant: participant, session_topic_1: session_topic_1} do
    message = " jeee"
    {:error, error_message} = SessionTopicService.board_message(participant.id, session_topic_1.id, %{"message" => message})
    assert(error_message == SessionTopicService.errors_messages.action_not_allowed)
  end
end
