defmodule KlziiChat.Services.AccountUserTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.AccountUser, as: AccountUserQueries
  alias KlziiChat.{Repo, SubscriptionPreference}

  test "can find SubscriptionPreference from account user ", %{account_user_account_manager: account_user_account_manager} do
     assert(%SubscriptionPreference{} = AccountUserQueries.get_subscription_preference_account_user(account_user_account_manager.id) |> Repo.one!)
  end
end
