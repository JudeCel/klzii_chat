defmodule KlziiChat.Services.SessionTopicReportingService do
  alias KlziiChat.Services.{FileService}
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.{Repo, SessionTopicView}
  alias KlziiChat.Helpers.DateTimeHelper
  alias KlziiChat.Queries.SessionTopic,  as: SessionTopicQueries


  import KlziiChat.Helpers.StringHelper, only: [double_quote: 1]

  @csv_header "Name,Comment,Date,Is tagged,Is reply,Emotion"

  @spec save_report(String.t, atom, integer, boolean, boolean) :: {:ok, String.t}
  def save_report(report_name, report_format, session_topic_id, filter_star, include_facilitator) do
    with {:ok, report_data} <- get_report(report_format, session_topic_id, filter_star, include_facilitator),
         {:ok, report_file_path} <- FileService.write_report(report_name, report_format, report_data),
    do:  {:ok, report_file_path}
  end

  @spec get_report(atom, integer, boolean, boolean) :: {:ok, Stream | String.t} | {:error, String.t}
  def get_report(report_format, session_topic_id, filter_star, include_facilitator) do
    session_topic =
      SessionTopicQueries.find(session_topic_id)
      |> Repo.one
      |> Phoenix.View.render_one(SessionTopicView, "show.json", as: :session_topic )

    messages = KlziiChat.Queries.Messages.session_topic_messages(session_topic_id, [ star: filter_star, facilitator: include_facilitator ])
      |> Repo.all

    case report_format do
      :txt -> {:ok, get_stream(:txt, messages, session_topic.session, session_topic, session_topic.session.account)}
      :csv -> {:ok, get_stream(:csv, messages, session_topic.session,  session_topic, session_topic.session.account)}
      :pdf -> {:ok, get_html(:html, messages, session_topic.session, session_topic, session_topic.session.account)}
      _ -> {:error, "Incorrect report format: " <> to_string(report_format)}
    end
  end

  @spec get_stream(Atom.t, List.t, Map.t, Map.t, Map.t) :: Stream.t
  def get_stream(:txt, messages, %{name: session_name}, %{name: session_topic_name}, _) do
    stream = Stream.map(messages, fn (%{body: body}) -> "#{body}\r\n\r\n" end)
    header = "#{session_name} / #{session_topic_name}\r\n\r\n"

    Stream.concat([header], stream)
  end
  def get_stream(:csv, messages, %{timeZone: time_zone}, _, _) do
    stream = Stream.map(messages, &message_csv_filter(&1, time_zone))
    Stream.concat([csv_header], stream)
  end

  @spec csv_header() :: String.t
  def csv_header do
    @csv_header <> "\r\n"
  end

  @spec message_csv_filter(Map.t,  String.t) :: String.t
  def message_csv_filter(%KlziiChat.Message{session_member: %{username: username}, body: body, createdAt: createdAt, star: star,
    replyId: replyId, emotion: emotion}, time_zone) do
    {:ok, emotion_name} = MessageDecorator.emotion_name(emotion)

    ~s(#{double_quote(username)},#{double_quote(body)},#{double_quote(DateTimeHelper.report_format(createdAt, time_zone))},#{to_string(star)},#{to_string(replyId != nil)},#{emotion_name}\r\n)
  end

  @spec get_html(Atom.t, List.t, Map.t, Map.t, Map.t) :: {String.t}
  def get_html(:html, messages, session, session_topic, account) do
    Phoenix.View.render_to_string(
      KlziiChat.Reporting.PreviewView, "messages.html",
      messages: messages,
      brand_logo: session.brand_logo,
      time_zone: session.timeZone,
      session_topic_name: session_topic.name,
      header_title: "Chat History - #{account.name} / #{session.name}",
      layout: {KlziiChat.LayoutView, "report.html"}
    )
  end
end
