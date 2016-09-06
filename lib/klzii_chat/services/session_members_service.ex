defmodule KlziiChat.Services.SessionMembersService do
  alias KlziiChat.{Repo, Message, AccountUser, SessionMember, SessionMembersView}
  import Ecto.Query, only: [from: 2]

  @spec get_member_from_token(String.t) :: {:ok, %AccountUser{}} | {:error, String.t}
  def get_member_from_token(token) do
    with {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, member} <- KlziiChat.Guardian.Serializer.from_token(claims["sub"]),
     do: {:ok, member, claims["callback_url"]}
  end

  @spec update_member(Integer.t, Map.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def update_member(id, params) do
    session_member =  Repo.get_by!(SessionMember, id: id)
    SessionMember.changeset(session_member, params)
    |> update_member
  end

  @spec update_emotion(Integer) :: Map.t
  def update_emotion(message_id) do
    message =  Repo.get_by!(Message, id: message_id) |> Repo.preload([:session_member, :session_topic])
    params = %{"avatarData" => %{"face"=> message.emotion}}
    update_session_topic_context(message.session_member, message.session_topic.id, params)
  end

  @spec update_session_topic_context(%SessionMember{}, Integer, Map.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def update_session_topic_context(session_member, session_topic_id, params) do
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
        where: sm.sessionId == ^session_id,
        order_by: sm.id
    result = Repo.all(query)
    {:ok, group_by_role(result)}
  end

  @spec group_by_role(List.t) :: Map.t
  def group_by_role(members) do
    Phoenix.View.render(SessionMembersView, "group_by_role.json", %{ members: members})
  end
end
