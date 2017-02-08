defmodule KlziiChat.SurveyAnswersView do
  use KlziiChat.Web, :view

  @spec render(String.t, Map.t) :: Map.t
  def render("report.json", %{survey_answer: survey_answer}) do
    %{
      id: survey_answer.id,
      survey_id: survey_answer.surveyId,
      answers: survey_answer.answers
    }
  end
end
