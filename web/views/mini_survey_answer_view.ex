defmodule KlziiChat.MiniSurveyAnswerView do
  use KlziiChat.Web, :view

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{mini_survey_answer: mini_survey_answer}) do
    %{
      id: mini_survey_answer.id,
      answer: mini_survey_answer.answer
    }
  end
end
