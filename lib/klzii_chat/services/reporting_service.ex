defmodule KlziiChat.Services.ReportingService do
  alias KlziiChat.Services.{MessageService}
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.HTMLReportingHelper
  alias Ecto.DateTime

  @tmp_path "/tmp/klzii_chat/reporting"

  def write_to_file(report_name, report_format, session_member, session, session_topic) when report_format in [:txt, :csv] do
    report_file_path = Path.join(@tmp_path, report_name) <> "." <> to_string(report_format)

    {:ok, file} = File.open(report_file_path, [:write])

    get_stream(report_format, session, session_topic, session_member)
    |> Enum.each(&(:ok = IO.write(file, &1)))

    :ok = File.close(file)
    {:ok, report_file_path}
  end

  def write_to_file(report_name, :pdf, session_member, session, session_topic) do
    html_tmp_file_path = Path.join(@tmp_path, report_name) <> ".html"
    pdf_report_file_path = Path.join(@tmp_path, report_name) <> ".pdf"

    {:ok, html_tmp_file} = File.open(html_tmp_file_path, [:write])
    html_text = get_html(session, session_topic, session_member)
    :ok = IO.write(html_tmp_file, html_text)
    :ok = File.close(html_tmp_file)

    {_, 0} = System.cmd("wkhtmltopdf", ["file://" <> html_tmp_file_path, pdf_report_file_path], stderr_to_stdout: true)
    #:ok = File.rm(html_tmp_file_path)
    {:ok, pdf_report_file_path}
  end

  def get_stream(report_format, session, session_topic, session_member) do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    stream = Stream.map(topic_history, &topic_hist_filter(report_format, &1))
    header = get_header(report_format, session.name, session_topic.name)
    Stream.concat([header], stream)
  end

  def get_header(:txt, session_name, session_topic_name), do: "#{session_name} / #{session_topic_name}\r\n\r\n"
  def get_header(:csv, _, _), do: "name,comment,date,is tagged,is reply,emotion\r\n"
  def get_header(:html, session_name, session_topic_name), do: "#{session_name} : #{session_topic_name}"

  def topic_hist_filter(:csv, %{body: body, emotion: emotion, replyId: replyId, session_member: %{username: name},
    star: star, time: time}) do

    "#{name},#{body},#{DateTime.to_string(time)},#{to_string(star)},#{to_string(replyId !== nil)}," <>
      "#{MessageDecorator.emotion_name(emotion)}\r\n"
  end

  def topic_hist_filter(:txt, %{body: body}), do: "#{body}\r\n\r\n"

  def get_html(session, session_topic, session_member) do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    HTMLReportingHelper.html_from_template(%{
      header: get_header(:html, session.name, session_topic.name),
      topic_history: topic_history,
      emoticon: %{emoticons_qnt: 7, sprites_qnt: 6, emoticon_size: [55, 55]}
    })
  end
end
