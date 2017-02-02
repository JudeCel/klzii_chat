defmodule KlziiChat.SurveyView do
  use KlziiChat.Web, :view
  alias KlziiChat.{ ResourceView, SurveyQuestionView, SurveyAnswersView }

  @spec render(String.t, Map.t) :: Map.t
  def render("survey.json", %{survey: survey}) do
    %{
      id: survey.id,
      resource: render_one(survey.resource, ResourceView, "resource.json"),
      SurveyQuestions: render_many(survey.survey_questions, SurveyQuestionView, "show.json")
    }
  end
  def render("report.json", %{survey: survey}) do
    %{
      id: survey.id,
      name: survey.name,
      resource: render_one(survey.resource, ResourceView, "resource.json"),
      survey_questions: render_many(survey.survey_questions, SurveyQuestionView, "report.json"),
      survey_answers: render_many(survey.survey_answers, SurveyAnswersView, "report.json", as: :survey_answer)
    }
  end
end
