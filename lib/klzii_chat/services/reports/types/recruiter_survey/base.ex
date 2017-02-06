defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Base do
  alias KlziiChat.{Repo, Survey}
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.{Formats}
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.Statistic
  import Ecto.Query, only: [from: 2]

  @spec format_modeule(String.t) :: Module.t
  def format_modeule("pdf"), do: {:ok, Formats.Pdf}
  def format_modeule("xlsx"), do: {:ok, Formats.Xlsx}
  def format_modeule(format), do: {:error, "module for format #{format} not found"}

  def get_data(%{id: id}) do
    with {:ok, survey} <- get_recruiter_survey(%{id: id}),
         {:ok, header_title} <- get_header_title(survey),
    do:  {:ok, %{
              "recruiter_survey" => survey,
              "survey_questions_stats" => calculate_stats(survey),
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
        from(s in Survey, where: [id: ^id], preload: [:survey_answers, :resource, survey_questions: [:resource]])
        |> Repo.one
    {:ok, Phoenix.View.render( KlziiChat.SurveyView,"report.json", %{survey: survey})}
  end
  def get_recruiter_survey(_), do: {:error, %{not_reqired: "recruiter survey id not reqired"}}

  def calculate_stats(survey) do
    survey_questions_task = Task.async(fn -> Statistic.build_questions(survey.survey_questions) end)
    survey_answers_task = Task.async(fn -> Statistic.map_answers(Enum.map(survey.survey_answers, &(&1.answers))) end)

    survey_questions = Task.await(survey_questions_task)
    survey_answers = Task.await(survey_answers_task)

    questions = Statistic.map_question_list_answers(survey_questions, survey_answers)

    %{questions: questions, total_count: Enum.count(survey.survey_answers), total_count_percents: 100 }
  end
end
