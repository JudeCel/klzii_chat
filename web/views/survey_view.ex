defmodule KlziiChat.SurveyView do
  use KlziiChat.Web, :view
  alias KlziiChat.{ ResourceView, SurveyQuestionView }

  @spec render(String.t, Map.t) :: Map.t
  def render("survey.json", %{survey: survey}) do
    %{
      id: survey.id,
      resource: render_one(survey.resource, ResourceView, "resource.json"),
      SurveyQuestions: render_many(survey.survey_questions, SurveyQuestionView, "show.json")
    }
  end
end
