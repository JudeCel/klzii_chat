defmodule KlziiChat.Queries.Sessions do
  alias KlziiChat.{Session, SessionTopic}
  import Ecto.Query, only: [from: 2]

  @spec find(Integer) :: Ecto.Query.t
  def find(session_id) do
    session_topic_query = from(st in SessionTopic, order_by: [ desc: st.order])
    from(s in Session,
      where: s.id == ^session_id,
      where: s.active == true,
      preload: [:brand_project_preference, session_topics: ^session_topic_query]
    )
  end
end
