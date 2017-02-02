defmodule KlziiChat.SurveysController do
  use KlziiChat.Web, :controller
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
  
  def export(conn, %{"id" => id, format: format}) do
    data = KlziiChat.Services.Reports.Types.RecruiterSurvey.Base.get_data(%{id: id})
    case format do
      "pdf" ->
        json(conn, %{ok: format})
      "xlsx" ->
          json(conn, %{ok: format})
      _ ->
        json(conn, %{error: "wrong format"})
    end
  end
end
