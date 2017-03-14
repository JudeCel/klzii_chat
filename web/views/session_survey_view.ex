defmodule KlziiChat.SessionSurveyView do
  use KlziiChat.Web, :view
  alias KlziiChat.{ SurveyView }

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{session_survey: session_survey}) do
    %{
      id: session_survey.id,
      survey: render_one(session_survey.survey, SurveyView, "survey.json", as: :survey)
    }
  end
end
