defmodule KlziiChat.Queries.Shapes do
  alias KlziiChat.{SessionMember, SessionTopic, Shape}

  import Ecto
  import Ecto.Query

  @spec base_query(%SessionTopic{}) :: Ecto.Query
  def base_query(%{id: nil}) do
    from(s in Shape, order_by: [asc: :id])
  end
  def base_query(%{id: id}) do
    from(s in Shape, where: [id: ^id],
      order_by: [asc: :id]
    )
  end

  @spec find_shapes_for_delete(%SessionMember{}, %SessionTopic{}) :: Ecto.Query.t
  def find_shapes_for_delete(%SessionMember{role: "facilitator"}, session_topic) do
    from s in assoc(session_topic, :shapes)
  end

  @spec find_shapes_for_delete(%SessionMember{}, %SessionTopic{}) :: Ecto.Query.t
  def find_shapes_for_delete(%SessionMember{role: "participant", id: id}, session_topic) do
    from s in assoc(session_topic, :shapes),
    where: s.sessionMemberId == ^id
  end
end
