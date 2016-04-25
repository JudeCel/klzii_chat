defmodule KlziiChat.SurveysController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Survey, Repo, SurveyView}
  import Ecto

  def show(conn, %{"id" => id}) do
    survey =
      Repo.get(Survey, id)
      case Repo.get(Survey, id) do
        nil ->
          json(conn, %{status: :error, reason: "not found"})
        survey ->
          survey = Repo.preload(survey, [:resource, survey_questions: [:resource]])
          json(conn, %{survey: SurveyView.render("survey.json", %{survey: survey}) })
      end


    # case ResourceService.find(account_user.id, id ) do
    #   {:ok, resource} ->
    #     json(conn, %{resource: ResourceView.render("resource.json", %{resource: resource}) })
    #   {:error, reason} ->
    #     json(conn, %{status: :error, reason: reason})
    # end
  end
end
