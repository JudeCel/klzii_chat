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

    base_query = QueriesMessages.base_query(session_topic_1.id)
    star_true_query = QueriesMessages.filter_star(base_query, true)

    {:ok, base_query: base_query, star_true_query: star_true_query, facilitator: facilitator, participant: participant,
      create_date1: create_date1, create_date2: create_date2, session_topic_id: session_topic_1.id}
  end

  test "base query - all messages unsorted", %{base_query: base_query} do
    message_count =
      base_query
      |> Repo.all()
      |> Enum.count()

    star_false_query =
      base_query
      |> QueriesMessages.filter_star(false)

    assert(star_false_query == base_query)
    assert(message_count == 2)
  end

  test "base query - filter star message", %{star_true_query: star_true_query} do
    [%{star: true}] =
      star_true_query
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

  test "base query stars only joins session member - 1 message", %{star_true_query: star_true_query} do
    [%{star: true, session_member: %{}}] =
      star_true_query
      |> QueriesMessages.join_session_member()
      |> Repo.all
  end

  test "base query joins session member and excludes host - 1 message", %{base_query: base_query} do
    [%{session_member: %{role: "participant"}}] =
      base_query
      |> QueriesMessages.join_session_member()
      |> QueriesMessages.exclude_by_role("facilitator", false)
      |> Repo.all

  end

  test "base query joins session member and excludes participant - 1 message", %{base_query: base_query} do
  [%{session_member: %{role: "facilitator"}}] =
      base_query
      |> QueriesMessages.join_session_member()
      |> QueriesMessages.exclude_by_role("participant", false)
      |> Repo.all
  end


  test "sort and select from all messages", %{base_query: base_query} do
      messages = base_query
      |> QueriesMessages.join_session_member()
      |> Repo.all
    assert(Enum.count(messages) == 2)
  end

  test "empty result for stars only and exlude host request", %{star_true_query: star_true_query} do
    [] =
      star_true_query
      |> QueriesMessages.join_session_member()
      |> QueriesMessages.exclude_by_role("facilitator", false)
      |> Repo.all
  end

  test "Get session topic messages", %{session_topic_id: session_topic_id} do
    [%{star: true, session_member: %{role: "facilitator"}}, %{star: false, session_member: %{role: "participant"}}] =
      QueriesMessages.session_topic_messages(session_topic_id, star: false, facilitator: true)
      |> Repo.all

    [%{star: true, session_member: %{role: "facilitator"}}] =
      QueriesMessages.session_topic_messages(session_topic_id, star: true, facilitator: true)
      |> Repo.all

    [%{star: false, session_member: %{role: "participant"}}] =
      QueriesMessages.session_topic_messages(session_topic_id, star: false, facilitator: false)
      |> Repo.all

    [] =
      QueriesMessages.session_topic_messages(session_topic_id, star: true, facilitator: false)
      |> Repo.all
    end
end
