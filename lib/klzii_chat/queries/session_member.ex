defmodule KlziiChat.Queries.SessionMember do
  import Ecto.Query, only: [from: 2]
  alias KlziiChat.{SessionMember}

  @spec permissions(integer) :: Ecto.Query.t
  def permissions(session_member_id) do
    from(
      sm in SessionMember,
      where: [id: ^session_member_id],
      preload: [:account_user]
    )
  end
end
