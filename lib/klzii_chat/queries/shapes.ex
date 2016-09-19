defmodule KlziiChat.Queries.Shapes do
  alias KlziiChat.{SessionMember, SessionTopic, Shape}

  import Ecto
  import Ecto.Query

  @spec base_query(%SessionTopic{}) :: Ecto.Query
  def base_query(session_topic) do
    from(s in assoc(session_topic, :shapes))
  end

  @spec find_shapes_for_delete(%SessionMember{}, %SessionTopic{}) :: Ecto.Query.t
  def find_shapes_for_delete(%SessionMember{role: "facilitator"}, session_topic) do
    base_query(session_topic)
  end

  @spec find_shapes_for_delete(%SessionMember{}, %SessionTopic{}) :: Ecto.Query.t
  def find_shapes_for_delete(%SessionMember{role: "participant", id: id}, session_topic) do
    from s in base_query(session_topic),
    where: s.sessionMemberId == ^id
  end
end
