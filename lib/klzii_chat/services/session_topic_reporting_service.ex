defmodule KlziiChat.Services.SessionTopicReportingService do
  alias KlziiChat.Services.{FileService}
  alias KlziiChat.Decorators.MessageDecorator
  alias Ecto.DateTime
  alias KlziiChat.{Repo, SessionTopic}

  import KlziiChat.Helpers.StringHelper, only: [double_quote: 1]

  @spec save_report(String.t, atom, integer, boolean, boolean) :: {:ok, String.t}
  def save_report(report_name, report_format, session_topic_id, filter_star, include_facilitator) do
    with {:ok, report_data} <- get_report(report_format, session_topic_id, filter_star, include_facilitator),
         {:ok, report_file_path} <- FileService.write_report(report_name, report_format, report_data),
    do:  {:ok, report_file_path}
  end

  @spec get_report(atom, integer, boolean, boolean) :: {:ok, Stream | String.t} | {:error, String.t}
  def get_report(report_format, session_topic_id, filter_star, include_facilitator) do
    session_topic = Repo.get(SessionTopic, session_topic_id) |> Repo.preload([session: :account])

    messages = KlziiChat.Queries.Messages.session_topic_messages(session_topic_id, [ star: filter_star, facilitator: include_facilitator ] )
      |> Repo.all

    case report_format do
      :txt -> {:ok, get_stream(:txt, messages, session_topic.session.name, session_topic.name)}
      :csv -> {:ok, get_stream(:csv, messages, session_topic.session.name,  session_topic.name)}
      :pdf -> {:ok, get_html(:html, messages, session_topic.name, session_topic.session.name, session_topic.session.account.name)}
      _ -> {:error, "Incorrect report format: " <> to_string(report_format)}
    end
  end

  @spec get_stream(:txt, List.t, String.t, String.t) :: Stream.t
  def get_stream(:txt, messages, session_name, session_topic_name) do
    stream = Stream.map(messages, fn (%{body: body}) -> "#{body}\r\n\r\n" end)
    header = "#{session_name} / #{session_topic_name}\r\n\r\n"

    Stream.concat([header], stream)
  end


  @spec csv_header() :: String.t
  def csv_header do
    "Name,Comment,Date,Is tagged,Is reply,Emotion\r\n"
  end

  @spec get_stream(:csv, List.t, String.t, String.t) :: Stream.t
  def get_stream(:csv, messages, _, _) do
    stream = Stream.map(messages, &message_csv_filter(&1))
    Stream.concat([csv_header], stream)
  end

  @spec message_csv_filter(Map.t) :: String.t
  def message_csv_filter(%KlziiChat.Message{session_member: %{username: username}, body: body, createdAt: createdAt, star: star,
    replyId: replyId, emotion: emotion}) do
    {:ok, emotion_name} = MessageDecorator.emotion_name(emotion)

    ~s(#{double_quote(username)},#{double_quote(body)},#{double_quote(DateTime.to_string(createdAt))},#{to_string(star)},#{to_string(replyId != nil)},#{emotion_name}\r\n)
  end

  @spec get_html(Atom.t, List.t, String.t, String.t, String.t) :: {String.t}
  def get_html(:html, messages, session_topic_name, session_name, account_name) do
    Phoenix.View.render_to_string(
      KlziiChat.Reporting.MessagesView, "messages.html",
      messages: messages,
      session_topic_name: session_topic_name,
      header_title: "Chat History - #{account_name} / #{session_name}",
      layout: {KlziiChat.LayoutView, "report.html"}
    ) |> IO.inspect
  end
end
