defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Base do

  alias KlziiChat.{Repo, Survey}
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.{Formats}
  import Ecto.Query, only: [from: 2]

  @spec format_modeule(String.t) :: Module.t
  def format_modeule("pdf"), do: {:ok, Formats.Pdf}
  def format_modeule("xlsx"), do: {:ok, Formats.Csv}
  def format_modeule(format), do: {:error, "module for format #{format} not found"}

  def get_data(report) do
    with {:ok, survey} <- get_recruiter_survey(report),
         {:ok, header_title} <- get_header_title(survey),
    do:  {:ok, %{
              "recruiter_survey" => survey,
              "stats" => calculate_stats(survey),
              "header_title" => header_title,
            }
          }
  end

  @spec get_header_title(Map.t) :: {:ok, String.t}
  def get_header_title(%{name: name}) do
    {:ok, "#{name}"}
  end

  @spec get_recruiter_survey(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_recruiter_survey(%{id: id}) do
      survey =
        from(s in Survey, where: [id: ^id], preload: [:survey_questions, :survey_answers])
        |> Repo.one
    {:ok, survey}
  end
  def get_recruiter_survey(_), do: {:error, %{not_reqired: "recruiter survey id not reqired"}}

  def calculate_stats(survey) do
    %{questions: []}
  end
  # def get_session_topics(report) do
  #   data =
  #     preload_session_topic(report)
  #     |> Phoenix.View.render_many(SessionTopicView, "report.json", as: :session_topic)
  #   {:ok, data}
  # end
  #
  # def preload_session_topic(%{sessionTopicId: nil, sessionId: session_id} = report) do
  #   SessionTopicQueries.all(session_id)
  #   |> Repo.all
  #   |> Repo.preload([mini_surveys: preload_mini_survey_query(report)])
  # end
  #
  # def preload_session_topic(%{sessionTopicId: sessionTopicId} = report) do
  #   from(st in SessionTopic,
  #     where: st.id == ^sessionTopicId,
  #     preload: [mini_surveys: ^preload_mini_survey_query(report)]
  #   ) |> Repo.all
  # end
  #
  # def preload_mini_survey_query(report) do
  #   includes_facilitator = !get_in(report.includes, ["facilitator"])
  #   QueriesMiniSurvey.report_query(report.sessionTopicId, !includes_facilitator)
  # end
end
