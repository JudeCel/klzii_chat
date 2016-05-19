defmodule KlziiChat.Services.SessionMembersService do
  alias KlziiChat.{Repo, SessionMember, SessionMembersView}
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

  @spec update_member(Integer.t, Map.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def update_member(id, params) do
    session_member =  Repo.get_by!(SessionMember, id: id)
    SessionMember.changeset(session_member, params)
    |> update_member
  end

  @spec update_emotion(Integer, Integer, Integer) :: Map.t
  def update_emotion(session_member_id, session_topic_id, emotion) do
    params = %{"avatar" => %{"emotion"=> emotion}}
    update_session_topic_context(session_member_id, session_topic_id, params)
  end

  @spec update_session_topic_context(Integer, Integer, Map.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def update_session_topic_context(session_member_id, session_topic_id, params) do
    session_member =  Repo.get_by!(SessionMember, id: session_member_id)
    session_topic_context = merge_session_topic_context(session_member.sessionTopicContext, params, session_topic_id)
    SessionMember.changeset(session_member, %{sessionTopicContext: session_topic_context})
    |> update_member
  end

  @spec merge_session_topic_context(Map.t, Map.t, Integer) :: Map.t
  def merge_session_topic_context(current_context, params, session_topic_id) do
    key = to_string(session_topic_id)
    new_context = Map.put_new(current_context, key, %{})
    session_topic_map =  Map.get(new_context, key) |> Map.merge(params)
    Map.put(new_context, key, session_topic_map)
  end

  @spec update_member(Ecto.Changeset.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  defp update_member(changeset) do
    case Repo.update(changeset) do
      {:ok, session_member} ->
        {:ok, session_member}
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
