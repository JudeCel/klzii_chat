defmodule KlziiChat.Services.MiniSurveysService do
  alias KlziiChat.{Repo, MiniSurvey, MiniSurveyAnswer, SessionTopic, SessionMember}
  import Ecto
  import Ecto.Query, only: [from: 2]

  def get(_session_member_id, %{"sessionTopicId" => session_topic_id}) do
    # session_member = Repo.get!(SessionMember, session_member_id)
    mini_surveys = from(ms in MiniSurvey, where: ms.sessionTopicId == ^session_topic_id)
    |> Repo.all
    {:ok, mini_surveys}
  end

  def create(session_member_id, %{"sessionTopicId" => session_topic_id, "type" => type, "question" => question, "title" => title} ) do
    _session_member = Repo.get!(SessionMember, session_member_id)
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    build_assoc(session_topic, :mini_surveys, %{
      sessionId: session_topic.sessionId,
      type: type,
      question: question,
      title: title
    })
      |> Repo.insert
  end

  def create_answer(session_member_id, mini_survey_id, answer) do
    session_member = Repo.get!(SessionMember, session_member_id)
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
          {:ok, Repo.preload(mini_survey ,[mini_survey_answers: from(msa in MiniSurveyAnswer, where: msa.id == ^answer.id)])}
        {:error, reason} ->
          {:error, reason}
      end
  end

  def get_for_console(session_member_id, mini_survey_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    mini_survey = Repo.get!(MiniSurvey, mini_survey_id)
    |> Repo.preload([mini_survey_answers: from(msa in MiniSurveyAnswer, where: msa.sessionMemberId == ^session_member.id)])
    {:ok, mini_survey}
  end
end
