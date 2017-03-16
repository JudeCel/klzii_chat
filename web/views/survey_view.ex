defmodule KlziiChat.SurveyView do
  use KlziiChat.Web, :view
  alias KlziiChat.{ ResourceView, SurveyQuestionView, SurveyAnswersView }

  @spec render(String.t, Map.t) :: Map.t
  def render("survey.json", %{survey: survey}) do
    %{
      id: survey.id,
      url: survey.url,
      resource: render_one(resource(survey.resource), ResourceView, "resource.json"),
      SurveyQuestions: render_many(survey_questions(survey.survey_questions), SurveyQuestionView, "show.json")
    }
  end
  def render("report.json", %{survey: survey}) do
    %{
      id: survey.id,
      name: survey.name,
      type: survey.surveyType,
      resource: render_one(survey.resource, ResourceView, "resource.json"),
      survey_questions: render_many(survey.survey_questions, SurveyQuestionView, "report.json"),
      survey_answers: render_many(survey.survey_answers, SurveyAnswersView, "report.json", as: :survey_answer)
    }
  end
  def render("survey_preview.json", %{survey: survey}) do
    %{
      id: survey.id,
      url: survey.url,
      type: survey.surveyType
    }
  end



  defp resource(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  defp resource(resource), do: resource
  defp survey_questions(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp survey_questions(survey_questions), do: survey_questions
end
