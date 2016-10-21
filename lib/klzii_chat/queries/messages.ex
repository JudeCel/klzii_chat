defmodule KlziiChat.Queries.Messages do
  alias KlziiChat.{Message, SessionMember}
  import Ecto.Query, only: [from: 2]

  # this is a hotfix for DE923 should be replaced by TA1330
  @spec base_query(integer| nil) :: Ecto.Query
  def base_query(nil) do
    from message in Message,
    where: is_nil(message.replyId),
    where: [replayLevel: 0],
    order_by: [asc: :createdAt]
  end
  def base_query(session_topic_id) do
    from message in Message,
    where: message.sessionTopicId == ^session_topic_id,
    where: is_nil(message.replyId),
    where: [replyLevel: 0],
    order_by: [asc: :createdAt]
  end


  @spec join_session_member(Ecto.Query) :: Ecto.Query
  def join_session_member(query) do
    from message in query,
    join: session_member in SessionMember,
    on: session_member.id == message.sessionMemberId,
    preload: [session_member: session_member]
  end

  @spec filter_star(Ecto.Query, true) :: Ecto.Query
  def filter_star(query, true) do
    from message in query,
    where: message.star == true
  end

  @spec filter_star(Ecto.Query, false) :: Ecto.Query
  def filter_star(query, false), do: query

  @spec exclude_by_role(Ecto.Query, String.t, boolean) :: Ecto.Query
  def exclude_by_role(query, role, false) when is_bitstring(role) do
    from [message, session_member] in query,
    where: session_member.role != ^role
  end
  def exclude_by_role(query, _, true), do: query


  # this is a hotfix for DE923 should be replaced by TA1330
  @spec join_replies(Ecto.Query) :: Ecto.Query
  def join_replies(query) do
    replies_query = from(st in Message, where: [replyLevel: 2], order_by: [asc: :createdAt], preload: [:session_member, :votes, :replies])
    replies_nested_query = from(st in Message, where: [replyLevel: 1], order_by: [asc: :createdAt], preload: [:session_member, :votes, replies: ^replies_query])
    from message in query,
    preload: [replies: ^replies_nested_query]
  end

  @spec join_votes(Ecto.Query) :: Ecto.Query
  def join_votes(query) do
    from message in query,
    preload: [:votes]
  end


  @spec session_topic_messages(integer, List.t) :: Ecto.Query
  def session_topic_messages(session_topic_id, [star: star, facilitator: facilitator]) do
    session_topic_id
    |> base_query
    |> join_session_member
    |> exclude_by_role("facilitator", facilitator)
    |> filter_star(star)
    |> join_votes
    |> join_replies
  end
end
