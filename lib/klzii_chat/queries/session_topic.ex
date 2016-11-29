defmodule KlziiChat.Queries.SessionTopic do
  alias KlziiChat.{SessionTopic, Message}
  import Ecto.Query, only: [from: 2]

  @spec find(Integer) :: Ecto.Query.t
  def find(session_topic_id) do
    from(s in SessionTopic,
      where: s.id == ^session_topic_id,
      preload: [session: [:brand_logo, :account, :brand_project_preference]]
    )
    |> include_messages_info
  end

  @spec all(Integer) :: Ecto.Query.t
  def all(session_id) do
    from(st in SessionTopic,
      where: st.active == true and st.sessionId == ^session_id,
      order_by: [ asc: st.order, asc: st.topicId]
    )
    |> include_messages_info
  end

  @spec include_messages_info(Ecto.Query.t) :: Ecto.Query.t
  defp include_messages_info(query) do
    messages_query = from(m in Message, select: m.sessionMemberId, distinct: true)
    from(st in query,
      preload: [messages: ^messages_query]
    )
  end

end
