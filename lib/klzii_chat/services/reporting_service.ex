defmodule KlziiChat.Services.ReportingService do
  alias KlziiChat.Services.{MessageService, SessionMembersService}
  alias Ecto.DateTime
  require EEx

  def write_to_file(path, report_format, session_member, session, session_topic) when report_format in [:txt, :csv] do
    {:ok, report_stream} = get_stream(report_format, session, session_topic, session_member)

    {:ok, file} = File.open(path, [:write])
    Enum.each(report_stream, &IO.write(file, &1))
    File.close(file)
  end

  def write_to_file(path_to_file, :pdf, session_member, session, session_topic) do
    #{:ok, topic_history} = MessageService.history(session_topic.id, session_member)
    {:ok, session_members} = SessionMembersService.by_session(session.id)

    html = topic_history_HTML(System.cwd(), session.name, session_topic.name, topic_history, session_members)
    Porcelain.exec("wkhtmltopdf", ["-", path_to_file], in: html, out: :string, err: :out)
  end

  def get_stream(report_format, session, session_topic, session_member) do
    report_headers = [txt: "#{session.name} / #{session_topic.name}\r\n\r\n",
      csv: "name,comment,date,is tagged,is reply,emotion\r\n"]
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    stream = Stream.map(topic_history, &topic_hist_filter(report_format, &1))
    [report_headers[report_format] | stream]
  end

  def topic_hist_filter(:svn, %{body: body, emotion: emotion, replyId: replyId, session_member: %{username: name},
    star: star, time: time}) do

    "#{name},#{body},#{DateTime.to_string(time)},#{to_string(star)},#{to_string(replyId !== nil)},#{emotion}\r\n"
  end

  def topic_hist_filter(:txt, %{body: body}), do: "#{body}\r\n\r\n"

  def topic_history_HTML(base_path, session_name, session_topic_name, topic_history, session_members) do
    EEx.eval_file(Path.absname("web/templates/report/topic_history_report.html.eex", base_path), [
      base_path: base_path,
      session_name: session_name,
      session_topic_name: session_topic_name,
      topic_history: topic_history,
      session_members: session_members
    ])
  end

   EEx.function_from_file :def, :sample, "sample.eex", [:a, :b]

end
