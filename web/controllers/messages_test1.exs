defmodule KlziiChat.Queries.MessagesTest  do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.Messages, as: QueriesMessages

  setup %{session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 0,
      star: true,
      createdAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 1,
      star: false,
      createdAt: create_date2
    ) |> Repo.insert!()

    base_query = QueriesMessages.base_query(session_topic_1.id, false)
    base_query_star_only = QueriesMessages.base_query(session_topic_1.id, true)

    {:ok, base_query: base_query, base_query_star_only: base_query_star_only, facilitator: facilitator, participant: participant, create_date1: create_date1, create_date2: create_date2}
  end

  test "base query - all messages unsorted", %{base_query: base_query} do
    message_count =
      base_query
      |> Repo.all()
      |> Enum.count()

    assert(message_count == 2)
  end

  test "base query - star message", %{base_query_star_only: base_query_star_only} do
    [%{star: true}] =
      base_query_star_only
      |> Repo.all()
  end

  test "base query joins session member - all messages unsorted", %{base_query: base_query} do
    [message1, message2] =
      base_query
      |> QueriesMessages.join_session_member()
      |> Repo.all
    assert(Map.get(message1, :session_member) != nil)
    assert(Map.get(message2, :session_member) != nil)
  end

  test "base query stars only joins session member - 1 message", %{base_query_star_only: base_query_star_only} do
    [%{star: true, session_member: %{}}] =
      base_query_star_only
      |> QueriesMessages.join_session_member()
      |> Repo.all
  end

  test "base query joins session member and excludes facilitator- 1 message", %{base_query: base_query} do
    query =
      base_query
      |> QueriesMessages.join_session_member()
      |> QueriesMessages.exclude_facilitator()

    [%{session_member: %{role: "participant"}}] =
      from([message, session_member] in query, preload: [:session_member])
      |> Repo.all
  end

  test "sort and select from all messages", %{base_query: base_query, create_date1: create_date1,
    create_date2: create_date2, facilitator: %{username: username1}, participant: %{username: username2}} do
    [message1, message2] =
      base_query
      |> QueriesMessages.join_session_member()
      |> QueriesMessages.sort_select()
      |> Repo.all

      %{createdAt: ^create_date1, session_member: %{username: ^username1}} = message1
      %{createdAt: ^create_date2, session_member: %{username: ^username2}} = message2
  end

  test "empty result for stars only and exlude facilitator request", %{base_query_star_only: base_query_star_only} do
    [] =
      base_query_star_only
      |> QueriesMessages.join_session_member()
      |> QueriesMessages.exclude_facilitator()
      |> QueriesMessages.sort_select()
      |> Repo.all
  end
end
