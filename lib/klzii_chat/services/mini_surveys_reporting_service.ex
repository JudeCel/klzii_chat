defmodule KlziiChat.Services.MiniSurveysReportingService do
  alias KlziiChat.{Repo, MiniSurvey, SessionTopic}
  alias KlziiChat.Services.{FileService}
  alias KlziiChat.Decorators.MiniSurveyAnswersDecorator
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  import KlziiChat.Helpers.StringHelper, only: [double_quote: 1]
  alias Ecto.DateTime

  @spec save_report(String.t, atom, integer, boolean) :: {:ok | :error, String.t}
  def save_report(report_name, report_format, session_topic_id, include_facilitator) do
    with {:ok, report_data} <- get_report(report_format, session_topic_id, include_facilitator),
         {:ok, report_file_path} <- FileService.write_report(report_name, report_format, report_data),
    do:  {:ok, report_file_path}
  end

  @spec get_report(atom, integer, boolean) :: {:ok | :error, List.t | Stream.t}
  def get_report(report_format, session_topic_id, include_facilitator) do
    mini_surveys =
      QueriesMiniSurvey.report_query(session_topic_id, include_facilitator)
      |> Repo.all

    session_topic = Repo.get(SessionTopic, session_topic_id) |> Repo.preload([session: :account])

    case report_format do
      :txt -> {:ok, get_stream(:txt, mini_surveys, session_topic.session.name, session_topic.name)}
      :csv -> {:ok, get_stream(:csv, mini_surveys, session_topic.session.name, session_topic.name)}
      :pdf -> {:ok, get_html(mini_surveys, session_topic)}
      _ -> {:error, "Incorrect report format: " <> to_string(report_format)}
    end
  end

  @spec get_stream(atom, List.t, String.t, String.t) :: Stream.t
  def get_stream(:txt, mini_surveys, session_name, session_topic_name) do
    stream = Stream.map(mini_surveys, &format_survey_txt(&1))
    Stream.concat(["#{session_name} / #{session_topic_name}\r\n\r\n"], stream)
  end

  @spec get_stream(atom, List.t, String.t, String.t) :: Stream.t
  def get_stream(:csv, mini_surveys, _, _) do
    stream = Stream.map(mini_surveys, &format_survey_csv(&1))
      Stream.concat(["Title,Question,Name,Answer,Date\n\r"], stream)
  end

  @spec format_survey_txt(Map.t) :: List.t
  def format_survey_txt(%{title: title, question: question, mini_survey_answers: mini_survey_answers}) do
    answers =
      Enum.map(mini_survey_answers, fn %{answer: %{"type" => answer_type, "value" => answer_value}} ->
        {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)
        "#{answer_text}\r\n"
      end)
    ["#{title} / #{question}\r\n" | answers] ++ ["\r\n"]
  end

  @spec format_survey_csv(Map.t) :: List.t
  def format_survey_csv(%{title: title, question: question, mini_survey_answers: mini_survey_answers}) do
    Enum.map(mini_survey_answers, fn %{answer: %{"type" => answer_type, "value" => answer_value}, session_member: %{username: name}, createdAt: date} ->
      {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)
      "#{double_quote(title)},#{double_quote(question)},#{double_quote(name)},#{answer_text},#{double_quote(DateTime.to_string(date))}\r\n"
    end)
  end

  @spec get_html(List.t, %MiniSurvey{} ) :: String.t
  def get_html(mini_surveys, session_topic) do
    header_title = "Mini Surveys History - #{session_topic.session.account.name} / #{session_topic.session.name}"

    Phoenix.View.render_to_string(
      KlziiChat.Reporting.PreviewView, "mini_surveys.html",
      mini_surveys: mini_surveys,
      session_topic_name: session_topic.name,
      header_title: header_title,
      layout: {KlziiChat.LayoutView, "report.html"}
    )
  end
end
