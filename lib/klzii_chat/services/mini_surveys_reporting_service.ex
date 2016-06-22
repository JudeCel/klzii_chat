defmodule KlziiChat.Services.MiniSurveysReportingService do
  alias KlziiChat.{Repo, MiniSurvey, MiniSurveyAnswer}
  #alias KlziiChat.Helpers.HTMLWhiteboardReportHelper
  alias KlziiChat.Services.FileService

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

  def format_survey_txt(%{id: id, title: title, type: type, question: question}) do
    answers_stream =
      get_mini_survey_answers(id)
      |> Stream.map(fn %{answer: %{"type" => answer_type, "value" => answer_value}} ->
          answer_value  #DECORATOR
         end)
    Stream.concat(["\n\r", "#{title} / #{question} / #{type}\n\r"], [answers_stream, "\n\r"])
  end


  @spec get_mini_survey_answers(integer) :: Map
  def get_mini_survey_answers(survvey_id) do
    Repo.all(
      from msa in MiniSurveyAnswer,
      where: msa.miniSurveyId == ^survvey_id,
      order_by: [asc: msa.updatedAt]
    )
  end

end
