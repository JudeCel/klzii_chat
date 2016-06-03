defmodule KlziiChat.Services.ReportingService do
  alias KlziiChat.Repo
  alias KlziiChat.Services.{FileService, MessageService}
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.HTMLReportingHelper
  alias KlziiChat.Queries.Messages, as: QueriesMessages
  alias Ecto.DateTime

  @tmp_path Path.expand("/tmp/klzii_chat/reporting")
  @emoticons %{emoticons_qnt: 7, sprites_qnt: 6, emoticon_size: [55, 55]}

  def write_to_file(report_name, :txt, session_member, session, session_topic) do
    txt_report_file_path = FileService.compose_path(@tmp_path, report_name, "txt")
    report_data_stream = get_stream(:txt, session, session_topic, session_member)

    :ok = FileService.write_data(txt_report_file_path, report_data_stream)
    {:ok, txt_report_file_path}
  end

  def write_to_file(report_name, :csv, session_member, session, session_topic) do
    csv_report_file_path = FileService.compose_path(@tmp_path, report_name, "csv")
    report_data_stream = get_stream(:csv, session, session_topic, session_member)

    :ok = FileService.write_data(csv_report_file_path, report_data_stream)
    {:ok, csv_report_file_path}
  end

  def write_to_file(report_name, :pdf, session_member, session, session_topic) do
    html_tmp_file_path = FileService.compose_path(@tmp_path, report_name, "html")
    pdf_report_file_path = FileService.compose_path(@tmp_path, report_name, "pdf")

    html_text = get_html(session, session_topic, session_member)
    :ok = FileService.write_data(html_tmp_file_path, html_text)

    case System.cmd("wkhtmltopdf", ["file://" <> html_tmp_file_path, pdf_report_file_path], stderr_to_stdout: true) do
      {_, 0} ->
        :ok = File.rm(html_tmp_file_path)
        {:ok, pdf_report_file_path}
      {stdout, _} -> {:error, stdout}
    end
  end

  def get_messages(session_topic_id, star_only, exclude_facilitator) do
    query = QueriesMessages.base_query(session_topic_id, star_only)
    query = QueriesMessages.join_session_member(query)
    if exclude_facilitator, do: query = QueriesMessages.exclude_facilitator(query)
    query = QueriesMessages.sort_select(query)

    Repo.all(query)
  end


  def get_stream(report_format, session, session_topic, session_member) do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    stream = Stream.map(topic_history, &topic_hist_filter(report_format, &1))
    header = get_header(report_format, session.name, session_topic.name)
    Stream.concat([header], stream)
  end

  def get_html(session, session_topic, session_member) do
    {:ok, topic_history} = MessageService.history(session_topic.id, session_member)

    HTMLReportingHelper.html_from_template(%{
      header: get_header(:html, session.name, session_topic.name),
      topic_history: topic_history,
      emoticon: @emoticons
    })
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
end
