defmodule KlziiChat.Services.SessionTopicReportingService do
  alias KlziiChat.Services.{FileService, SessionTopicService}
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.HTMLSessionTopcReportHelper
  alias Ecto.DateTime

  @tmp_path Path.expand("/tmp/klzii_chat/reporting")
  @emoticon_parameters %{emoticons_qnt: 7, sprites_qnt: 6, emoticon_size: [55, 55]}

  @spec save_report(String.t, atom, integer, boolean, boolean) :: {:ok, String.t}
  def save_report(report_name, report_format, session_topic_id, star_only, exclude_facilitator) when report_format in [:txt, :csv, :pdf] do
    {:ok, report_data} = get_report(report_format, session_topic_id, star_only, exclude_facilitator)
    {:ok, report_file_path} = write_report(report_name, report_format, report_data)
    {:ok, report_file_path}
  end

  @spec get_report(atom, integer, boolean, boolean) :: {:ok, Stream | String.t} | {:error, String.t}
  def get_report(report_format, session_topic_id, star_only, exclude_facilitator) do
    messages = SessionTopicService.get_messages(session_topic_id, star_only, exclude_facilitator)
    {session_name, session_topic_name} = SessionTopicService.get_session_and_topic_names(session_topic_id)

    case report_format do
      :txt -> {:ok, get_stream(:txt, messages, session_name, session_topic_name)}
      :csv -> {:ok, get_stream(:csv, messages, session_name, session_topic_name)}
      :pdf -> {:ok, get_html(messages, session_name, session_topic_name)}
      _ -> {:error, "incorrect report type"}
    end
  end

  @spec get_stream(:txt, list, String.t, String.t) :: Stream.t
  def get_stream(:txt, messages, session_name, session_topic_name) do
    stream = Stream.map(messages, fn (%{body: body}) -> "#{body}\r\n\r\n" end)
    header = "#{session_name} / #{session_topic_name}\r\n\r\n"

    Stream.concat([header], stream)
  end

  @spec get_stream(:csv, list, String.t, String.t) :: Stream.t
  def get_stream(:csv, messages, _, _) do
    stream = Stream.map(messages, &message_csv_filter(&1))
    header = "name,comment,date,is tagged,is reply,emotion\r\n"

    Stream.concat([header], stream)
  end

  def message_csv_filter(%{session_member: %{username: username}, body: body, createdAt: createdAt, star: star,
    replyId: replyId, emotion: emotion}) do

    "#{username},#{body},#{DateTime.to_string(createdAt)},#{to_string(star)},#{to_string(replyId !== nil)}," <>
      "#{MessageDecorator.emotion_name(emotion)}\r\n"
  end

  @spec get_html(list, String.t, String.t) :: {String.t}
  def get_html(messages, session_name, session_topic_name) do
    HTMLSessionTopcReportHelper.html_from_template(%{
      header: "#{session_name} : #{session_topic_name}",
      messages: messages,
      emoticon_parameters: @emoticon_parameters
    })
  end

  @spec write_report(String.t, :pdf, String.t | Stream.t) :: {:ok, String.t}
  def write_report(report_name, :pdf, report_data) do
    tmp_html_file_path = FileService.compose_path(@tmp_path, report_name, "html")
    :ok = FileService.write_data(tmp_html_file_path, report_data)
    FileService.html_to_pdf(tmp_html_file_path)
  end

  @spec write_report(String.t, atom, String.t | Stream.t) :: {:ok, String.t}
  def write_report(report_name, report_format, report_data) when report_format in [:txt, :csv]  do
    report_file_path = FileService.compose_path(@tmp_path, report_name, to_string(report_format))
    :ok = FileService.write_data(report_file_path, report_data)
    {:ok, report_file_path}
  end
end
