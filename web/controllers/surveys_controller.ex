defmodule KlziiChat.SurveysController do
  use KlziiChat.Web, :controller
  # import KlziiChat.ErrorHelpers, only: [error_view: 1]
  alias KlziiChat.{Survey, Repo, SurveyView}
  import Ecto.Query, only: [from: 2]

  def show(conn, %{"id" => id}) do
    from(s in Survey, preload: [:resource, survey_questions: [:resource]])
    |> Repo.get(id)
    |> case do
      nil ->
        json(conn, %{status: :error, reason: "not found"})
      survey ->
        json(conn, %{survey: SurveyView.render("survey.json", %{survey: survey}) })
    end
  end
end
