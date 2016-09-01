defmodule KlziiChat.Queries.Sessions do
  alias KlziiChat.{Session, SessionTopic, SubscriptionPreference}
  import Ecto.Query, only: [from: 2]

  @spec find(Integer) :: Ecto.Query.t
  def find(session_id) do
    session_topic_query = from(st in SessionTopic, where: st.active == true, order_by: [ asc: st.order])
    from(s in Session,
      where: s.id == ^session_id,
      preload: [:brand_project_preference, session_topics: ^session_topic_query]
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
end
