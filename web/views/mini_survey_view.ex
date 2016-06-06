defmodule KlziiChat.MiniSurveyView do
  use KlziiChat.Web, :view
  alias KlziiChat.MiniSurveyAnswerView

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{mini_survey: mini_survey}) do
    %{
      id: mini_survey.id
    }
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("show_with_answer.json", %{mini_survey: mini_survey}) do
    %{
      id: mini_survey.id,
      mini_survey_answer: render_one(List.last(mini_survey.mini_survey_answers), MiniSurveyAnswerView, "show.json")
    }
  end
end
