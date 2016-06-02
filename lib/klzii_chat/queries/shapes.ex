defmodule KlziiChat.Queries.Shapes do
  import Ecto
  import Ecto.Query

  alias KlziiChat.{SessionMember, SessionTopic}

  @spec find_shapes_for_delete(%SessionMember{}, %SessionTopic{}) :: Ecto.Query.t
  def find_shapes_for_delete(%SessionMember{role: "facilitator"}, session_topic) do
    from(s in assoc(session_topic, :shapes))
  end

  @spec find_shapes_for_delete(%SessionMember{}, %SessionTopic{}) :: Ecto.Query.t
  def find_shapes_for_delete(%SessionMember{role: "participant", id: id}, session_topic) do
    from(s in assoc(session_topic, :shapes), where: s.sessionMemberId == ^id)
  end
end
