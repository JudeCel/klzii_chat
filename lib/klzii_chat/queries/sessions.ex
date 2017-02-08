defmodule KlziiChat.Queries.Sessions do
  alias KlziiChat.{Session, SubscriptionPreference, Account}
  import Ecto.Query, only: [from: 2]

  @spec find(Integer) :: Ecto.Query.t
  def find(session_id) do
    session_topic_query = KlziiChat.Queries.SessionTopic.all(session_id)
    from(s in Session,
      where: s.id == ^session_id,
      preload: [:brand_logo, :brand_project_preference, session_topics: ^session_topic_query]
    )
  end

  @spec find_for_report(Integer) :: Ecto.Query.t
  def find_for_report(session_id) do
    from(s in Session,  where: s.id == ^session_id,
    preload: [ :account, :brand_logo, :brand_project_preference,
      [ participant_list: [ contact_list_users: [:account_user] ]] ]
    )
  end

  @spec find_for_report_statistic(Integer) :: Ecto.Query.t
  def find_for_report_statistic(session_id) do
    from(s in Session,  where: s.id == ^session_id,
    preload: [:session_topics, :account, :session_members,
    [ participant_list: [ contact_list_users: [:account_user] ]]]
    )
  end

  @spec get_subscription_preference_session(integer) :: Ecto.Query.t
  def get_subscription_preference_session(sessionId) do
    from(sp in SubscriptionPreference,
    join: s in assoc(sp, :subscription),
    join: a in assoc(s, :account),
    join: session in assoc(a, :sessions),
    where: session.id == ^sessionId,
    preload: [:subscription]
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
