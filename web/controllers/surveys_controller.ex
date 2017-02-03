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

  def export(conn, %{"id" => id, "format" => format}) do
    data = KlziiChat.Services.Reports.Types.RecruiterSurvey.Base.get_data(%{id: id})

    case format do
      "pdf" ->
        conn
        |> put_resp_content_type("application/pdf")
        |> put_resp_header("content-disposition", "attachment; filename=\"A Real Pdf_pff.pdf\"")
        |> send_resp(200, "")
      "xlsx" ->
          json(conn, %{ok: format})
      _ ->
        json(conn, %{error: "wrong format"})
    end
  end
end
