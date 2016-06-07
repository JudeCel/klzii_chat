defmodule KlziiChat.MiniSurveyView do
  use KlziiChat.Web, :view
  alias KlziiChat.MiniSurveyAnswerView

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{mini_survey: mini_survey}) do
    %{
      id: mini_survey.id,
      title: mini_survey.title,
      question: mini_survey.question,
      type: mini_survey.type
    }
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("show_with_answer.json", %{mini_survey: mini_survey}) do
    mini_survey_answer = render_one(List.last(mini_survey.mini_survey_answers), MiniSurveyAnswerView, "show.json")

    render("show.json", %{mini_survey: mini_survey})
      |> Map.put(:mini_survey_answer, mini_survey_answer)
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("show_with_answers.json", %{mini_survey: mini_survey}) do
    mini_survey_answers = render_many(mini_survey.mini_survey_answers, MiniSurveyAnswerView, "show.json")
    render("show.json", %{mini_survey: mini_survey})
      |> Map.put(:mini_survey_answers, mini_survey_answers)
  end
end
