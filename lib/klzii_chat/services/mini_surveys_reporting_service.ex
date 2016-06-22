defmodule KlziiChat.Services.MiniSurveysReportingService do
  alias KlziiChat.{Repo, MiniSurvey, MiniSurveyAnswer, SessionMember}
  #alias KlziiChat.Helpers.HTMLWhiteboardReportHelper
  alias KlziiChat.Services.FileService
  alias KlziiChat.Decorators.MiniSurveyAnswersDecorator
  alias Ecto.DateTime

  import Ecto.Query, only: [from: 2]

  @spec save_report(String.t, atom, integer) :: {:ok | :error, String.t}
  def save_report(report_name, :txt, session_topic_id) do
    get_mini_surveys(session_topic_id)
    |> Stream.map(&format_survey_txt(&1))


  end

  @spec get_mini_surveys(integer) :: Map
  def get_mini_surveys(session_topic_id) do
    Repo.all(
      from ms in MiniSurvey,
      where: ms.sessionTopicId == ^session_topic_id
    )
  end

  @spec format_survey_txt(Map.t) :: Stream.t
  def format_survey_txt(%{id: id, title: title, question: question}) do
    answers_stream =
      get_mini_survey_answers(id)
      |> Stream.map(fn %{answer: %{"type" => answer_type, "value" => answer_value}} ->
          {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)
          answer_text
         end)

    Stream.concat(["\n\r", "#{title} / #{question}}\n\r"], [answers_stream, "\n\r"])
  end

  @spec format_survey_csv(Map.t) :: Stream.t
  def format_survey_csv(%{id: id, title: title, question: question}) do
    answers_stream =
      get_mini_survey_answers(id)
      |> Stream.map(fn %{answer: %{"type" => answer_type, "value" => answer_value, session_member: %{username: name}, createdAt: date}} ->
          {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)

          "#{title},#{question},#{name},#{answer_text},#{DateTime.to_string(date)}"
         end)

    Stream.concat(["\n\r", "#{title} / #{question}}\n\r"], [answers_stream, "\n\r"])
  end



  @spec get_mini_survey_answers(integer) :: Map
  def get_mini_survey_answers(survvey_id) do
    Repo.all(
      from msa in MiniSurveyAnswer,
      join: sm in assoc(msa, :session_member),
      where: msa.miniSurveyId == ^survvey_id,
      order_by: [asc: msa.updatedAt],
      preload: [session_member: sm ]
    )
  end

end
