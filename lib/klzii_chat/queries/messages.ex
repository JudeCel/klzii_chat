defmodule KlziiChat.Queries.Messages do
  alias KlziiChat.{Message, SessionMember}
  import Ecto.Query, only: [from: 2]

  @spec base_query(integer, false) :: Ecto.Query
  def base_query(session_topic_id, false) do
    from message in Message,
    where: message.sessionTopicId == ^session_topic_id
  end

  @spec base_query(integer, true) :: Ecto.Query
  def base_query(session_topic_id, true) do
    from message in Message,
    where: message.sessionTopicId == ^session_topic_id and message.star == true
  end

  @spec join_session_member(Ecto.Query) :: Ecto.Query
  def join_session_member(query) do
    from message in query,
    join: session_member in SessionMember,
    on: session_member.id == message.sessionMemberId
  end

  @spec exclude_facilitator(Ecto.Query) :: Ecto.Query
  def exclude_facilitator(query) do
    from [message, session_member] in query,
    where: session_member.role != "facilitator"
  end

  @spec sort_select(Ecto.Query) :: Ecto.Query
  def sort_select(query) do
    from [message, session_member] in query,
    order_by: [asc: message.createdAt],
    select: %{
      body: message.body,
      createdAt: message.createdAt,
      emotion: message.emotion,
      replyId: message.replyId,
      star: message.star,
      session_member: %{
        role: session_member.role,
        username: session_member.username
      }
    }
  end
end
