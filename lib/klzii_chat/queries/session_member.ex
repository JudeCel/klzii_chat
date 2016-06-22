defmodule KlziiChat.Queries.SessionMember do
  import Ecto
  import Ecto.Query
  alias KlziiChat.{SessionMember, SubscriptionPreference}

  @spec get_subscription_preference(integer) :: Ecto.Query.t
  def get_subscription_preference(sessionId) do
    from(sp in SubscriptionPreference,
    join: s in assoc(sp, :subscription),
    join: a in assoc(s, :account),
    join: session in assoc(a, :sessions),
    where: session.id == ^sessionId
    )
  end
end
