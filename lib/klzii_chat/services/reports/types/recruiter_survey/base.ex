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
        from(s in Survey, where: [id: ^id], preload: [:survey_questions, :survey_answers])
        |> Repo.one
    {:ok, survey}
  end
  def get_recruiter_survey(_), do: {:error, %{not_reqired: "recruiter survey id not reqired"}}

  def calculate_stats(survey) do
    survey_questions = survey.survey_questions
    survey_answers = survey.survey_answers

    # IO.inspect survey_questions
    survey_questions =
      survey.survey_questions
      |> Enum.map(&default_question_stats/1)
      |> IO.inspect

    %{questions: survey_questions, total_count: Enum.count(survey_answers)}
  end

  def default_question_stats(%{id: id, type: type, name: name, answers: answers}) do
    %{id: id, type: type, name: name, answers: map_answers(answers, %{}, type)}
  end

  def map_answers([head| tail], acc, type) do
    map_answers(head, acc, type)
    map_answers(tail, acc, type)
  end

  def map_answers(%{"contactDetails" => %{"age" => %{"options" => options}}} = answer, acc, type) do
    answer
  end
  def map_answers(answer, acc, type) do
    IO.inspect answer
    answer
  end
end
