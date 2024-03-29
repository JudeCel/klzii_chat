defmodule KlziiChat.Services.SessionsTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.Sessions, as: SessionsQueries
  alias KlziiChat.{Repo, SubscriptionPreference}

  test "when guest then select only own shapes for delete in session topic", %{session: session} do
     assert(%SubscriptionPreference{} = SessionsQueries.get_subscription_preference_session(session.id) |> Repo.one!)
  end

  test "can find session", %{session: session} do
    found_session = SessionsQueries.find(session.id)
      |> Repo.one
    assert(found_session.id == session.id)
  end

  test "is prelouded session topics and order", %{session: session} do
    session_topics = SessionsQueries.find(session.id)
      |> Repo.one
      |> Map.get(:session_topics)
    assert(session_topics |> Enum.count == 2)
    first = session_topics |> List.first
    last = session_topics |> List.last
    assert(last.order > first.order)
  end

  test "can't find session", %{session: session} do
    SessionsQueries.find(session.id + 99)
    |> Repo.one
    |> is_nil
    |> assert
  end
end
