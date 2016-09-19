defmodule KlziiChat.Queries.MiniSurvey do
  alias KlziiChat.{MiniSurvey, SessionMember, MiniSurveyAnswer}
  import Ecto.Query, only: [from: 2, from: 1]

  @spec base_query(integer) :: Ecto.Query
  def base_query(session_topic_id) do
    from mini_survey in MiniSurvey,
    where: mini_survey.sessionTopicId == ^session_topic_id,
    order_by: [asc: :createdAt]
  end

  def report_query(session_topic_id, include_facilitator) do
    base_query(session_topic_id)
    |> join_mini_survey_answers("facilitator", include_facilitator)

  end

  @spec join_mini_survey_answers(Ecto.Query, String.t, boolean) :: Ecto.Query
  def join_mini_survey_answers(query, role, state) do
    from mini_survey in query,
    preload: [mini_survey_answers: ^exclude_by_role(role, state)]
  end

  @spec exclude_by_role(String.t, boolean) :: Ecto.Query
  def exclude_by_role(role, false) when is_bitstring(role) do
    from msa in MiniSurveyAnswer,
    join: sm in assoc(msa, :session_member),
    where: sm.role != ^role,
    preload: [session_member: sm]
  end
  def exclude_by_role( _, true) do
    from msa in MiniSurveyAnswer,
    join: sm in assoc(msa, :session_member),
    preload: [session_member: sm]
  end

end
