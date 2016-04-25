defmodule KlziiChat.SurveyQuestionView do
  use KlziiChat.Web, :view
  alias KlziiChat.ResourceView

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{survey_question: survey_question}) do
    %{
      id: survey_question.id,
      resurce: render_one(survey_question.resource, ResourceView, "resource.json")
    }
  end
end
