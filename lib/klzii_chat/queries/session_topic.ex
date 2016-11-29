defmodule KlziiChat.Queries.SessionTopic do
  alias KlziiChat.{SessionTopic, Message}
  import Ecto.Query, only: [from: 2]

  @spec find(Integer) :: Ecto.Query.t
  def find(session_topic_id) do
    from(s in SessionTopic,
      where: s.id == ^session_topic_id,
      preload: [session: [:brand_logo, :account, :brand_project_preference]]
    )
  end

  @spec all(Integer) :: Ecto.Query.t
  def all(session_id) do
    from(st in SessionTopic,
      where: st.active == true and st.sessionId == ^session_id,
      order_by: [ asc: st.order, asc: st.topicId]
    )
  end

end
