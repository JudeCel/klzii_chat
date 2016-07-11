defmodule KlziiChat.Services.SessionMemberTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.SessionMember, as: SessionMemberQueries
  alias KlziiChat.{Repo, SubscriptionPreference}

  test "when participant then select only own shapes for delete in session topic", %{session: session} do
     assert(%SubscriptionPreference{} = SessionMemberQueries.get_subscription_preference_session_memeber(session.id) |> Repo.one!)
  end
end
