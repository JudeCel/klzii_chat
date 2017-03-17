defmodule KlziiChat.Services.Reports.Types.SurveyList.Base do
  alias KlziiChat.{Repo, Survey}
  alias KlziiChat.Services.Reports.Types.SurveyList.{Formats}
  alias KlziiChat.Services.Reports.Types.SurveyList.Statistic
  import Ecto.Query, only: [from: 2]

  @spec format_modeule(String.t) :: {:ok, Module.t} | {:error, String.t}
  def format_modeule("pdf"), do: {:ok, Formats.Pdf}
  def format_modeule("xlsx"), do: {:ok, Formats.Xlsx}
  def format_modeule(format), do: {:error, "module for format #{format} not found"}

  @spec get_data(Map.t) :: Map.t
  def get_data(%{ids: ids}) do
      with {:ok, surveys} <- get_surveys(%{ids: ids}),
      do:  {:ok, %{ "surveys" => get_survey_list(surveys), "name" => get_survey_name(surveys)}}
  end

  def get_survey_name(surveys) do
    Enum.at(surveys, 0).name
  end

  def get_survey_list(surveys) do
    Enum.map(surveys, fn(survey) ->
      %{
        "survey" => survey,
        "survey_questions_stats" => calculate_stats(survey),
        "header_title" => get_header_title(survey)
      }
    end)
  end

  @spec get_surveys(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_surveys(%{ids: ids}) do
      surveys =
        from(s in Survey, where: s.id in ^ids, preload: [:survey_answers, :resource, survey_questions: [:resource]])
        |> Repo.all
    {:ok, Phoenix.View.render_many(surveys, KlziiChat.SurveyView, "report.json", as: :survey)}
  end

  @spec get_header_title(Map.t) :: {:ok, String.t}
  def get_header_title(%{type: "sessionPrizeDraw"}) do
    "Contact List Questions"
  end

  @spec get_header_title(Map.t) :: {:ok, String.t}
  def get_header_title(%{type: "sessionContactList"}) do
    "Prize Draw"
  end

  @spec get_header_title(Map.t) :: {:ok, String.t}
  def get_header_title(_) do
    "Survey"
  end

  @spec get_survey(Map.t) :: {:ok, Map.t} | {:error, Map.t}
  def get_survey(%{id: id}) do

      survey =
        from(s in Survey, where: [id: ^id], preload: [:survey_answers, :resource, survey_questions: [:resource]])
        |> Repo.one
    {:ok, Phoenix.View.render( KlziiChat.SurveyView,"report.json", %{survey: survey})}
  end
  def get_survey(_), do: {:error, %{not_reqired: "survey id not reqired"}}

  @spec calculate_stats(Map.t) :: Map.t
  def calculate_stats(survey) do
    survey_questions_task = Task.async(fn -> Statistic.build_questions(survey.survey_questions) end)
    survey_answers_task = Task.async(fn -> Statistic.map_answers(Enum.map(survey.survey_answers, &(&1.answers))) end)
    survey_questions = Task.await(survey_questions_task)
    survey_answers = Task.await(survey_answers_task)

    questions = Statistic.map_question_list_answers(survey_questions, survey_answers)
    %{questions: questions, total_count: Enum.count(survey.survey_answers), total_count_percents: 100 }
  end
end
