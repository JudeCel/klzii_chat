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
    cond do
      format in ["pdf", "xlsx"] ->
        {:ok, format_modeule} = KlziiChat.Services.Reports.Types.RecruiterSurvey.Base.format_modeule(format)
        {:ok, data} = KlziiChat.Services.Reports.Types.RecruiterSurvey.Base.get_data(%{id: id})
        {:ok, html} = format_modeule.processe_data(data)
        {:ok, binary} = KlziiChat.Services.FileService.write_report(%{id: id, format: format, name: "some_name_now"},html, [binary: true])
        conn
        |> put_resp_content_type("application/#{format}")
        |> put_resp_header("content-disposition", "attachment; filename=\"#{data["header_title"]}.#{format}\"")
        |> send_resp(200, binary)
      true ->
        json(conn, %{error: "wrong format: #{format}"})
    end
  end
end
