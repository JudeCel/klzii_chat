defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Formats.Pdf do

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do

    # try do
      header =
        Phoenix.View.render_to_string(
          KlziiChat.Reporting.PreviewView, "header.html",
          brand_logo: get_in(data, ["recruiter_survey", :resource]),
          header_title: get_in(data, ["header_title"])
        )

      body = Phoenix.View.render_to_string(
        KlziiChat.Reporting.PreviewView, "recruiter_survey_stats.html",
        recruiter_survey: get_in(data, ["recruiter_survey"]),
        survey_questions_stats: get_in(data, ["survey_questions_stats"]),
        layout: {KlziiChat.LayoutView, "report.html"}
      )

      {:ok, %{body: body, header: header}}
    # catch
    #   :error, reason ->
    #     {:error, reason}
    # end
  end
end
