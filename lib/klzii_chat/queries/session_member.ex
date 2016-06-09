defmodule KlziiChat.Queries.SessionMember do
  import Ecto
  import Ecto.Query

  alias KlziiChat.{SessionMember, SubscriptionPreference}

  @spec get_subscription_preference(integer) :: Ecto.Query.t
  def get_subscription_preference(id) do
    from(sp in SubscriptionPreference,
    join: s in assoc(sp, :subscription),
    join: a in assoc(s, :account),
    join: au in assoc(a, :account_users),
    join: sm in assoc(au, :session_members),
    where: sm.id == ^id
    )
  end
end
