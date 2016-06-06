defmodule KlziiChat.MiniSurveyView do
  use KlziiChat.Web, :view

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{mini_survey: mini_survey}) do
    %{
      id: mini_survey.id
    }
  end
end
