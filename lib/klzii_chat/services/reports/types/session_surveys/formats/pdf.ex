defmodule KlziiChat.Services.Reports.Types.SurveyList.Formats.Pdf do

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    try do
      surveys = get_in(data, ["surveys"])

      header =
        Phoenix.View.render_to_string(
          KlziiChat.Reporting.PreviewView, "header.html",
          brand_logo: get_in(List.first(surveys), ["survey", :resource]),
          header_title: get_in(List.first(surveys), ["header_title"])
        )

        IO.puts header
      body = Phoenix.View.render_to_string(
        KlziiChat.Reporting.PreviewView, "session_survey_stats.html",
          surveys: surveys,
          survey: get_in(List.first(surveys), ["survey"]),
          survey_questions_stats: get_in(List.first(surveys), ["survey_questions_stats"]),
          layout: {KlziiChat.LayoutView, "report.html"}
      )
      {:ok, %{body: body, header: header}}
    catch
      :error, reason ->
        {:error, reason}
    end
  end
end
