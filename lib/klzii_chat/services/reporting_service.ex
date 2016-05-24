defmodule KlziiChat.Services.ReportingService do
  alias KlziiChat.Services.{MessageService, SessionMembersService}
  alias Ecto.DateTime

  def save_file(path_to_file, type, session_member, session, session_topic) when type in [:csv, :txt] do
    csv_header = "name,comment,date,is tagged,is reply,emotion\r\n"
    txt_header = "#{session.name} / #{session_topic.name}\r\n\r\n"
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    report_stream =
      case type do
        :csv -> topic_history_CSV_stream(csv_header, topic_history)
        :txt -> topic_history_TXT_stream(txt_header, topic_history)
      end

   {:ok, file} = File.open(path_to_file, [:write])
   Enum.each(report_stream, &IO.write(file, &1))
   :ok = File.close(file)
  end

  def save_file(path_to_file, type, session_member, session, session_topic) when type == :pdf do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)
    {:ok, session_members} = SessionMembersService.by_session(session.id)

    html = topic_history_HTML(System.cwd(), session.name, session_topic.name, topic_history, session_members)
    Porcelain.exec("wkhtmltopdf", ["-", path_to_file], in: html, out: :string, err: :out)
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

  def topic_history_HTML(base_path, session_name, session_topic_name, topic_history, session_members) do
    EEx.eval_file(Path.absname("web/templates/report/topic_history_report.html.eex", base_path), [
      base_path: base_path,
      session_name: session_name,
      session_topic_name: session_topic_name,
      topic_history: topic_history,
      session_members: session_members
    ])
  end

end
