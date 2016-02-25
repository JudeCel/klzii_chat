defmodule KlziiChat.Services.SessionMembersService do
  alias KlziiChat.{Repo, SessionMember, SessionMembersView}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def find_by_token(token) do
    case Repo.get_by(SessionMember, token: token) do
      nil ->
        nil
      session_member ->
        Phoenix.View.render(SessionMembersView, "session_member.json", session_member: session_member)
    end
  end

  def by_session(session_id) do
    query =
      from sm in SessionMember,
        where: sm.sessionId == ^session_id

    case Repo.all(query) do
      [] ->
        nil
      members ->
        group_by_role(members)
        {:ok, group_by_role(members)}
    end
  end

  def group_by_role(members) do
    accumulator = %{"facilitator" => %{}, "observer" =>  [], "participant" => []}

    Enum.reduce(members, accumulator, fn (member, acc) ->
      member_map = Phoenix.View.render(SessionMembersView, "session_member.json", %{ session_member: member})
      case Map.get(acc, member.role) do
        value when is_map(value) ->
          Map.put(acc, member.role, member_map)
        value when is_list(value) ->
          role_list = Map.get(acc, member.role)
          new_list = role_list ++ [member_map]
          Map.put(acc, member.role, new_list)
      end
    end)
  end
end
