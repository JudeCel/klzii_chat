defmodule KlziiChat.Services.MiniSurveysService do
  alias KlziiChat.{Repo, MiniSurvey, MiniSurveyAnswer, SessionTopic, SessionMember}
  alias KlziiChat.Services.{ConsoleService}
  alias KlziiChat.Services.Permissions.MiniSurveys, as: MiniSurveysPermissions
  import Ecto
  import Ecto.Query, only: [from: 2, from: 1]

  @spec get(Integer) :: {:ok, List}
  def get(session_topic_id) do
    mini_surveys = from(ms in MiniSurvey, where: ms.sessionTopicId == ^session_topic_id)
    |> Repo.all
    {:ok, mini_surveys}
  end

  @spec create(Integer, Integer, Map.t) :: {:ok, %MiniSurvey{}} | {:error, Ecto.Changeset.t}
  def create(session_member_id, session_topic_id, %{"type" => type, "question" => question, "title" => title} ) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if MiniSurveysPermissions.can_create(session_member) do
      session_topic = Repo.get!(SessionTopic, session_topic_id)
      build_assoc(session_topic, :mini_surveys, %{
        sessionId: session_topic.sessionId,
        type: type,
        question: question,
        title: title
      })
        |> Repo.insert
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec delete(Integer, Integer) :: {:ok, %MiniSurvey{}}
  def delete(session_member_id, id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    mini_survey = Repo.get!(MiniSurvey, id) |> Repo.preload([:consoles])
    if MiniSurveysPermissions.can_delete(session_member, mini_survey) do
      :ok = delete_related_consoles(mini_survey.consoles, session_member_id)
      Repo.delete(mini_survey)
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec delete_related_consoles(List, Integer) :: :ok
  def delete_related_consoles(consoles, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    ConsoleService.tidy_up(consoles, "miniSurvey", session_member.id)
    :ok
  end

  @spec create_answer(Integer, Integer, Map.t) :: {:ok, %MiniSurvey{}} | {:error, Ecto.Changeset.t}
  def create_answer(session_member_id, mini_survey_id, answer) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if MiniSurveysPermissions.can_answer(session_member) do
      mini_survey = Repo.get!(MiniSurvey, mini_survey_id)

      Repo.one(from msa in MiniSurveyAnswer,
        where: msa.sessionMemberId == ^session_member.id,
        where: msa.miniSurveyId == ^mini_survey.id
      )|> case  do
            nil ->
              build_assoc(mini_survey, :mini_survey_answers, %{
                sessionMemberId: session_member.id,
                answer: answer
              })
            mini_survey_answere ->
              mini_survey_answere
          end
        |> Ecto.Changeset.change([answer: answer])
        |> Repo.insert_or_update
        |> case do
          {:ok, answer } ->
            {:ok, Repo.preload(mini_survey ,[mini_survey_answers: from(msa in MiniSurveyAnswer, where: msa.id == ^answer.id, preload: [:session_member])])}
          {:error, reason} ->
            {:error, reason}
        end
      else
        {:error, "Action not allowed!"}
      end
  end

  @spec get_for_console(Integer, Integer) :: {:ok, %MiniSurvey{}}
  def get_for_console(session_member_id, mini_survey_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    mini_survey = Repo.get!(MiniSurvey, mini_survey_id)
    |> Repo.preload([mini_survey_answers: from(msa in MiniSurveyAnswer, where: msa.sessionMemberId == ^session_member.id, preload: [:session_member])])
    {:ok, mini_survey}
  end

  @spec get_with_answers(Integer) :: {:ok, %MiniSurvey{}}
  def get_with_answers(mini_survey_id) do
    mini_survey = Repo.get!(MiniSurvey, mini_survey_id)
    |> Repo.preload([mini_survey_answers: :session_member])
    {:ok, mini_survey}
  end
end
