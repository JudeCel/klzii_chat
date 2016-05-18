defmodule KlziiChat.Services.ReportingService do
  alias Ecto.DateTime

  def topic_history_CSV_stream(topic_history) do
    Stream.map(topic_history, &filter(&1))
    |> CSV.Encoder.encode(headers: true)
  end

  defp filter(%{body: body, emotion: emotion, replyId: replyId,
    session_member: %{username: name}, star: star, time: time}) do

    %{ "name" => name, "comment" => body, "date" => DateTime.to_string(time),
      "is tagged" => to_string(star), "is reply" => to_string(replyId == nil),
      "emotion" => emotion
    }
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
