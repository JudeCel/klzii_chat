defmodule KlziiChat.Services.Reports.Types.PrizeDraw.Base do
  alias KlziiChat.{Repo, SessionSurvey, SessionView, SessionSurveyView}
  alias KlziiChat.Queries.Sessions, as: SessionQueries
  alias KlziiChat.Services.Reports.Types.PrizeDraw.{Formats}

  import Ecto.Query, only: [from: 2]

  @spec format_modeule(String.t) :: {:ok, Module.t} | {:error, String.t}
  def format_modeule("csv"), do: {:ok, Formats.Csv}
  def format_modeule(format), do: {:error, "module for format #{format} not found"}

  @spec default_fields() :: List.t[String.t]
  def default_fields() do
    ["First Name", "Last Name", "Email", "Contact Number"]
  end


  @spec get_data(Map.t) :: Map.t
  def get_data(report) do
    with {:ok, session} <- get_session(report),
         {:ok, header_title} <- get_header_title(session),
         {:ok, prize_draw_survey} <- get_prize_draw_survey(report),
    do:  {:ok, %{
              "session" => session,
              "header_title" => header_title,
              "prize_draw_survey" => prize_draw_survey,
              "fields" => default_fields()
            }
          }
  end

  @spec get_header_title(Map.t) :: {:ok, String.t}
  def get_header_title(%{name: name}) do
    {:ok, "#{name}"}
  end

  @spec get_session(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_session(%{sessionId: session_id}) do
    session =
      SessionQueries.find_for_report(session_id)
      |> Repo.one
      |> Phoenix.View.render_one(SessionView, "report.json", as: :session)
    {:ok, session}
  end
  def get_session(_), do: {:error, %{not_reqired: "session id not reqired"}}

  @spec get_prize_draw_survey(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_prize_draw_survey(%{sessionId: session_id}) do
    session_survey =
      from(sy in SessionSurvey, where: [sessionId: ^session_id],
        left_join: s in assoc(sy, :survey),
        where: s.surveyType == "sessionPrizeDraw",
        preload: [survey: [:survey_answers]]
      )
      |> Repo.one
    {:ok, Phoenix.View.render(SessionSurveyView,"report.json", %{session_survey: session_survey})}
  end
  def get_prize_draw_survey(_), do: {:error, %{not_reqired: "prize draw survey id not reqired"}}
end
