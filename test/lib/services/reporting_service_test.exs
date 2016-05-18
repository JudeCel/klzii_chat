defmodule KlziiChat.Services.ReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.MessageService
  alias Ecto.DateTime

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
    {:ok, topic_history} = MessageService.history(session_topic_id, member)

    topic_history
    |> Stream.map(&filter(&1))
    |> CSV.Encoder.encode(headers: true)
    |> Enum.to_list()
    |> IO.inspect()

  end

  def filter(%{body: body, emotion: emotion, replyId: replyId,
    session_member: %{username: name}, star: star, time: time}) do

    %{"name" => name, "comment" => body, "date" => DateTime.to_string(time),
        "is tagged" => to_string(star), "emotion" => emotion}
  end

#  %{body: "test message 2", emotion: 2, has_voted: false, id: 105,
#   permissions: %{can_delete: true, can_edit: true, can_new_message: true,
#     can_reply: true, can_star: true, can_vote: true}, replies: [],
#   replyId: nil,
#   session_member: %{avatarData: %{"base" => 0, "body" => 0, "desk" => 0,
#       "face" => 3, "hair" => 0, "head" => 0}, colour: "00000", id: 507,
#     role: "facilitator", username: "cool member"}, star: false,
#   time: #Ecto.DateTime<2016-05-18 12:47:04>, votes_count: 0}

end
