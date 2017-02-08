defmodule KlziiChat.SurveyQuestionView do
  use KlziiChat.Web, :view
  alias KlziiChat.ResourceView

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{survey_question: survey_question}) do
    %{
      id: survey_question.id,
      resource: render_one(survey_question.resource, ResourceView, "resource.json")
    }
  end
  def render("report.json", %{survey_question: survey_question}) do
    %{
      id: survey_question.id,
      name: survey_question.name,
      question: survey_question.question,
      order: survey_question.order,
      type: survey_question.type,
      resource: render_one(survey_question.resource, ResourceView, "resource.json"),
      answers: survey_question.answers
    }
  end
end
