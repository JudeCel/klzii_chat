defmodule KlziiChat.Services.SessionMembersService do
  alias KlziiChat.{Repo, SessionMember, SessionMembersView}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  @spec find_by_token(String.t) :: nil | Map.t
  def find_by_token(token) do
    case Repo.get_by(SessionMember, token: token) do
      nil ->
        nil
      session_member ->
        Phoenix.View.render(SessionMembersView, "current_member.json", member: session_member)
    end
  end

  @spec update_online_status(Integer.t, Boolean.t) :: {:ok, Map.t} | {:error, Ecto.Changeset}
  def update_online_status(id, staus) do
    session_member = Repo.get_by!(SessionMember, id: id)
    changeset = Ecto.Changeset.change(session_member, %{online: staus})
    case Repo.update(changeset) do
      {:ok, session_member} ->
        {:ok, SessionMembersView.render("member.json", member: session_member)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec update_member(Integer.t, Map.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset}
  def update_member(id, params) do
    session_member =  Repo.get_by!(SessionMember, id: id)
    SessionMember.changeset(session_member, params)
    |> Repo.update
    |> case do
        {:ok, session_member} ->
          {:ok, SessionMembersView.render("member.json", member: session_member)}
        {:error, changeset} ->
          {:error, changeset}
      end
  end

  @spec by_session(Integer.t) :: {:ok, Map.t}
  def by_session(session_id) do
    query =
      from sm in SessionMember,
        where: sm.sessionId == ^session_id
    result = Repo.all(query)
    {:ok, group_by_role(result)}
  end

  @spec group_by_role(List.t) :: Map.t
  def group_by_role(members) do
    Phoenix.View.render(SessionMembersView, "group_by_role.json", %{ members: members})
  end
end
