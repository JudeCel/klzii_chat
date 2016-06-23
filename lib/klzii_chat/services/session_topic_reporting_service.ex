defmodule KlziiChat.Services.SessionTopicReportingService do
  alias KlziiChat.Services.{FileService, SessionTopicService}
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.HTMLSessionTopicReportHelper
  alias Ecto.DateTime

  import KlziiChat.Helpers.StringHelper, only: [double_quote: 1]

  @emoticon_parameters %{emoticons_qnt: 7, sprites_qnt: 6, emoticon_size: [55, 55], selected_emoticon: 3}

  @spec save_report(String.t, atom, integer, boolean, boolean) :: {:ok, String.t}
  def save_report(report_name, report_format, session_topic_id, filter_star, include_facilitator) do
    with {:ok, report_data} <- get_report(report_format, session_topic_id, filter_star, include_facilitator),
         {:ok, report_file_path} <- FileService.write_report(report_name, report_format, report_data),
    do:  {:ok, report_file_path}
  end

  @spec get_report(atom, integer, boolean, boolean) :: {:ok, Stream | String.t} | {:error, String.t}
  def get_report(report_format, session_topic_id, filter_star, include_facilitator) do
    messages = SessionTopicService.get_messages(session_topic_id, filter_star, include_facilitator)
    %{name: session_topic_name, session: %{name: session_name}} = SessionTopicService.get_session_topic_wsession(session_topic_id)

    case report_format do
      :txt -> {:ok, get_stream(:txt, messages, session_name, session_topic_name)}
      :csv -> {:ok, get_stream(:csv, messages, session_name, session_topic_name)}
      :pdf -> {:ok, get_html(messages, session_name, session_topic_name)}
      _ -> {:error, "Incorrect report format: " <> to_string(report_format)}
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
    header = "Name,Comment,Date,Is tagged,Is reply,Emotion\r\n"

    Stream.concat([header], stream)
  end

  def message_csv_filter(%{session_member: %{username: username}, body: body, createdAt: createdAt, star: star,
    replyId: replyId, emotion: emotion}) do
    {:ok, emotion_name} = MessageDecorator.emotion_name(emotion)

    ~s(#{double_quote(username)},#{double_quote(body)},#{double_quote(DateTime.to_string(createdAt))},#{to_string(star)},#{to_string(replyId != nil)},#{emotion_name}\r\n)
  end

  @spec get_html(list, String.t, String.t) :: {String.t}
  def get_html(messages, session_name, session_topic_name) do
    HTMLSessionTopicReportHelper.html_from_template(%{
      header: "#{session_name} : #{session_topic_name}",
      messages: messages,
      emoticon_parameters: @emoticon_parameters
    })
  end
end
