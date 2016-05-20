defmodule KlziiChat.Services.ReportingService do
  alias KlziiChat.Services.MessageService
  alias Ecto.DateTime
  @report_types [:csv, :txt, :pdf]

  def save_file(path_to_file, type, session_member, session, session_topic) when type in @report_types do
    {:ok, file} = File.open(path_to_file, [:write])
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    csv_header = "name,comment,date,is tagged,is reply,emotion\r\n"
    txt_header = "#{session.name} / #{session_topic.name}\r\n\r\n"

    report_stream =
      case type do
        :csv -> topic_history_CSV_stream(csv_header, topic_history)
        :txt -> topic_history_TXT_stream(txt_header, topic_history)
      end

   Enum.each(report_stream, &IO.write(file, &1))
   :ok = File.close(file)
  end

  def topic_history_CSV_stream(svn_header, topic_history) do
    svn_strings = Stream.map(topic_history, &to_svn_string(&1))
    Stream.concat([svn_header], svn_strings)
  end

  def to_svn_string(%{body: body, emotion: emotion, replyId: replyId, session_member: %{username: name},
    star: star, time: time}) do

    "#{name},#{body},#{DateTime.to_string(time)},#{to_string(star)},#{to_string(replyId !== nil)},#{emotion}\r\n"
  end

  def topic_history_TXT_stream(txt_header, topic_history) do
    txt_strings = Stream.map(topic_history, fn(%{body: body}) -> "#{body}\r\n\r\n" end)
    Stream.concat([txt_header], txt_strings)
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
