defmodule KlziiChat.Services.MiniSurveysReportingService do
  alias KlziiChat.{Repo, MiniSurvey, MiniSurveyAnswer, SessionMember}
  #alias KlziiChat.Helpers.HTMLWhiteboardReportHelper
  alias KlziiChat.Services.FileService
  alias KlziiChat.Decorators.MiniSurveyAnswersDecorator
  alias Ecto.DateTime

  import Ecto.Query, only: [from: 2]
  import KlziiChat.Helpers.StringHelper, only: [double_quote: 1]

  @spec save_report(String.t, atom, integer, boolean) :: {:ok | :error, String.t}
  def save_report(report_name, report_format, session_topic_id, include_facilitator) do

  end

  @spec get_report(atom, integer, boolean) :: {:ok | :error, List.t | Stream.t}
  def get_report(report_format, session_topic_id, include_facilitator) do
    mini_surveys = get_mini_surveys(session_topic_id)
    {session_name, session_topic_name} = SessionTopicService.get_session_and_topic_names(session_topic_id)

    case report_format do
      :txt -> {:ok, get_stream(:txt, mini_surveys, session_name, session_topic_name, include_facilitator)}
      :csv -> {:ok, get_stream(:csv, mini_surveys, session_name, session_topic_name, include_facilitator)}
      #:pdf -> {:ok, get_html(mini_surveys, session_name, session_topic_name, include_facilitator)}
      _ -> {:error, "Incorrect report format: " <> to_string(report_format)}
    end
  end

  @spec get_mini_surveys(integer) :: Map
  def get_mini_surveys(session_topic_id) do
    Repo.all(
      from ms in MiniSurvey,
      where: ms.sessionTopicId == ^session_topic_id,
      order_by: [asc: ms.createdAt]
    )
  end


  @spec get_stream(atom, List.t, String.t, String.t, boolean) :: Map
  def get_stream(:txt, mini_surveys, session_name, session_topic_name, include_facilitator) do
    stream = Stream.map(mini_surveys, &format_survey_txt(&1, include_facilitator))
    Stream.concat(["#{session_name} / #{session_topic_name}\r\n\r\n"], stream)
  end

  @spec get_stream(atom, List.t, String.t, String.t, boolean) :: Map
  def get_stream(:csv, mini_surveys, _, _, include_facilitator) do
    stream = Stream.map(mini_surveys, &format_survey_csv(&1, include_facilitator))
      Stream.concat(["Title,Question,Name,Answer,Date\n\r"], stream)
  end


  @spec format_survey_txt(Map.t, boolean) :: Stream.t
  def format_survey_txt(%{id: id, title: title, question: question}, facilitator) do
    answers =
      Enum.map(get_mini_survey_answers(id, facilitator), fn %{answer: %{"type" => answer_type, "value" => answer_value}} ->
        {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)
        "#{answer_text}\r\n"
      end)

    ["#{title} / #{question}\r\n" | answers]
  end

  @spec format_survey_csv(Map.t, boolean) :: Stream.t
  def format_survey_csv(%{id: id, title: title, question: question}, facilitator) do
    Enum.map(get_mini_survey_answers(id, facilitator), fn %{answer: %{"type" => answer_type, "value" => answer_value}, session_member: %{username: name}, createdAt: date} ->
      {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)
      "#{double_quote(title)},#{double_quote(question)},#{double_quote(name)},#{answer_text},#{double_quote(DateTime.to_string(date))}\r\n"
    end)
  end


  @spec get_mini_survey_answers(integer, boolean) :: Map
  def get_mini_survey_answers(survvey_id, true) do
    Repo.all(
      from msa in MiniSurveyAnswer,
      join: sm in assoc(msa, :session_member),
      where: msa.miniSurveyId == ^survvey_id,
      order_by: [asc: msa.createdAt],
      preload: [session_member: sm]
    )
  end

  @spec get_mini_survey_answers(integer, boolean) :: Map
  def get_mini_survey_answers(survvey_id, false) do
    Repo.all(
      from msa in MiniSurveyAnswer,
      join: sm in assoc(msa, :session_member),
      where: msa.miniSurveyId == ^survvey_id and sm.role != "facilitator",
      order_by: [asc: msa.createdAt],
      preload: [session_member: sm]
    )
  end
end
