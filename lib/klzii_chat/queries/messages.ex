defmodule KlziiChat.Queries.Messages do
  alias KlziiChat.{Message, SessionMember}
  import Ecto.Query, only: [from: 2]

  @spec base_query(integer) :: Ecto.Query
  def base_query(session_topic_id) do
    from message in Message,
    where: message.sessionTopicId == ^session_topic_id,
    where: is_nil(message.replyId),
    order_by: [asc: :createdAt]
  end


  @spec join_session_member(Ecto.Query) :: Ecto.Query
  def join_session_member(query) do
    from message in query,
    preload: [:session_member]
  end

  @spec join_replies(Ecto.Query) :: Ecto.Query
  def join_replies(query) do
    replies_query = from(st in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, :replies])
    from message in query,
    preload: [replies: ^replies_query]
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
    |> join_votes
    |> join_replies
  end
end
