defmodule KlziiChat.Services.MessagesServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.MessageService

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    parent_message =
      Ecto.build_assoc(
        session_topic_1, :messages,
        sessionTopicId: session_topic_1.id,
        sessionMemberId: facilitator.id,
        body: "test message 2",
        emotion: 1,
      ) |> Repo.insert!()

    reply_message =
      Ecto.build_assoc(
        session_topic_1, :messages,
        sessionTopicId: session_topic_1.id,
        sessionMemberId: participant.id,
        replyId: parent_message.id,
        body: "test message 1",
        emotion: 0,
      ) |> Repo.insert!()


    {:ok, session_topic_id: session_topic_1.id, participant: participant,
      parent_message: parent_message, reply_message: reply_message,
      session_name: session.name, session_topic_name: session_topic_1.name
    }
  end

  describe "when add star" do
    test "change message star field to opposite value", %{reply_message: reply_message, facilitator: facilitator} do
      assert({:ok, message} = MessageService.star(reply_message.id, facilitator))
      assert(message.star == !reply_message.star)
    end

    test "add children star  new element when add start", %{reply_message: reply_message, facilitator: facilitator} do
      assert({:ok, _} = MessageService.star(reply_message.id, facilitator))
        MessageService.get_message(reply_message.replyId)
        |> Map.get(:childrenStars)
        |> Enum.member?(reply_message.id)
        |> assert
    end

    test "remove children star element when remove  start", %{reply_message: reply_message, facilitator: facilitator} do
      assert({:ok, _} = MessageService.star(reply_message.id, facilitator))
      assert({:ok, _} = MessageService.star(reply_message.id, facilitator))
        MessageService.get_message(reply_message.replyId)
        |> Map.get(:childrenStars)
        |> Enum.member?(reply_message.id)
        |> refute
    end
  end
end
