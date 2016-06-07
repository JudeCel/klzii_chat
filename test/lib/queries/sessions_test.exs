defmodule KlziiChat.Services.SessionsTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.Sessions, as: SessionsQueries
  alias KlziiChat.{Repo, BrandProjectPreference}

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
    assert(first.order > last.order)
  end

  test "is prelouded brand project preference", %{session: session} do
      %BrandProjectPreference{} = SessionsQueries.find(session.id)
      |> Repo.one
      |> Map.get(:brand_project_preference)
  end

  test "can't find session", %{session: session} do
    SessionsQueries.find(session.id + 99)
    |> Repo.one
    |> is_nil
    |> assert
  end
end