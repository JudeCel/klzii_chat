defmodule KlziiChat.Queries.Sessions do
  alias KlziiChat.{Session, SessionTopic, SubscriptionPreference, Account}
  import Ecto.Query, only: [from: 2]

  @spec find(Integer) :: Ecto.Query.t
  def find(session_id) do
    session_topic_query = from(st in SessionTopic, where: st.active == true, order_by: [ asc: st.order, asc: st.topicId])
    from(s in Session,
      where: s.id == ^session_id,
      preload: [:brand_logo, :brand_project_preference, session_topics: ^session_topic_query]
    )
  end

  @spec get_subscription_preference_session(integer) :: Ecto.Query.t
  def get_subscription_preference_session(sessionId) do
    from(sp in SubscriptionPreference,
    join: s in assoc(sp, :subscription),
    join: a in assoc(s, :account),
    join: session in assoc(a, :sessions),
    where: session.id == ^sessionId
    )
  end

  @spec is_admin(integer) :: Ecto.Query.t
  def is_admin(sessionId) do
    from(a in Account,
    join: session in assoc(a, :sessions),
    where: session.id == ^sessionId,
    where: a.admin == true
    )
  end
end
