defmodule KlziiChat.Queries.MiniSurvey do
  alias KlziiChat.{MiniSurvey}
  import Ecto.Query, only: [from: 2]

  @spec base_query(integer) :: Ecto.Query
  def base_query(session_topic_id) do
    from mini_survey in MiniSurvey,
    where: mini_survey.sessionTopicId == ^session_topic_id,
    preload: [mini_survey_answers: [:session_member]],
    order_by: [asc: :createdAt]
  end
end
