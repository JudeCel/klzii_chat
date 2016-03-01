defmodule KlziiChat.Services.SessionMembersService do
  alias KlziiChat.{Repo, SessionMember, SessionMembersView}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def find_by_token(token) do
    case Repo.get_by(SessionMember, token: token) do
      nil ->
        nil
      session_member ->
        Phoenix.View.render(SessionMembersView, "member.json", member: session_member)
    end
  end

  def by_session(session_id) do
    query =
      from sm in SessionMember,
        where: sm.sessionId == ^session_id
    result = Repo.all(query)
    {:ok, group_by_role(result)}
  end

  def group_by_role(members) do
    Phoenix.View.render(SessionMembersView, "group_by_role.json", %{ members: members})
  end
end
