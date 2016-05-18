defmodule KlziiChat.Services.ReportingService do
  alias Ecto.DateTime

  def topic_history_CSV_stream(topic_history) do
    svn_header = "name,comment,date,is tagged,is reply,emotion\r\n"
    svn_strings = Stream.map(topic_history, &to_svn_string(&1))
    Stream.concat([svn_header], svn_strings)
  end

  def to_svn_string(%{body: body, emotion: emotion, replyId: replyId, session_member: %{username: name},
    star: star, time: time}) do

    "#{name},#{body},#{DateTime.to_string(time)},#{to_string(star)},#{to_string(replyId !== nil)},#{emotion}\r\n"
  end

  def topic_history_TXT_stream(topic_history) do
    Stream.map(topic_history, fn(%{body: body}) -> "#{body}\r\n\r\n" end)
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
