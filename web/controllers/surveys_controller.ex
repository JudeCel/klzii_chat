defmodule KlziiChat.SurveysController do
  use KlziiChat.Web, :controller
  alias KlziiChat.{Survey, Repo, SurveyView, SessionSurvey}
  import KlziiChat.Services.SessionMembersService, only: [get_member_from_token: 1]

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

  def export(conn, %{"id" => id, "format" => format, "token" => token}) do
    case get_member_from_token(token) do
      {:ok, _, _} ->
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
      {:error, reason } ->
        json(conn, %{error: reason})
    end
  end

  def session_surveys(id) do
    from(ss in SessionSurvey, where: ss.sessionId == ^id, select: {ss.surveyId})
    |> Repo.all
    |> Enum.map(fn ({id})-> id end)
  end

  def export_session_surveys(conn, %{"id" => id, "format" => format, "token" => token}) do
      surveyIds = session_surveys(id)
      export_list_with_ids(conn, format, token, surveyIds)
  end

  def export_list(conn, %{"format" => format, "token" => token, "ids" => ids}) do
    parts=String.split ids, ","
    export_list_with_ids(conn, format, token, parts)
  end

  def export_list_with_ids(conn, format, token, ids) do
    case get_member_from_token(token) do
      {:ok, _, _} ->
        cond do
          format in ["pdf", "xlsx"] ->
            {:ok, format_modeule} = KlziiChat.Services.Reports.Types.SessionSurveys.Base.format_modeule(format)
            {:ok, data} = KlziiChat.Services.Reports.Types.SessionSurveys.Base.get_data(%{ids: ids})
            {:ok, html} = format_modeule.processe_data(data)
            {:ok, binary} = KlziiChat.Services.FileService.write_report(%{id: Enum.at(ids, 0), format: format, name: "some_name_now"},html, [binary: true])
            fileName =  get_in(data, ["name"])
            conn
            |> put_resp_content_type("application/#{format}")
            |> put_resp_header("content-disposition", "attachment; filename=\"#{fileName}.#{format}\"")
            |> send_resp(200, binary)
          true ->
              json(conn, %{error: "wrong format: #{format}"})
          end
      {:error, reason } ->
        json(conn, %{error: reason})
    end
  end

end
