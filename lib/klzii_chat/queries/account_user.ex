defmodule KlziiChat.Queries.AccountUser do
  import Ecto.Query, only: [from: 2]
  alias KlziiChat.{SubscriptionPreference, Account}

  @spec get_subscription_preference_account_user(integer) :: Ecto.Query.t
  def get_subscription_preference_account_user(account_id) do
    from(sp in SubscriptionPreference,
      join: s in assoc(sp, :subscription),
      join: a in assoc(s, :account),
      join: au in assoc(a, :account_users),
      where: au.id == ^account_id
    )
  end
  @spec is_admin(integer) :: Ecto.Query.t
  def is_admin(account_id) do
    from(a in Account,
      join: au in assoc(a, :account_users),
      where: au.id == ^account_id,
      where: a.admin == true
    )
  end
end
