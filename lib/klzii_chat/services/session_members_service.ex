defmodule KlziiChat.Services.SessionMembersService do
  alias KlziiChat.{Repo, Message, AccountUser, SessionMember, SessionMembersView, SessionTopic, Endpoint}
  alias KlziiChat.Services.Permissions.Builder, as: PermissionsBuilder
  import Ecto.Query, only: [from: 2]

  @spec get_member_from_token(String.t) :: {:ok, %AccountUser{}} | {:error, String.t}
  def get_member_from_token(token) do
    with {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, member} <- KlziiChat.Guardian.Serializer.from_token(claims["sub"]),
     do: {:ok, member, claims["callback_url"]}
  end

  def validate(session_member, %{"username" => _ }) do
    KlziiChat.Services.Permissions.Member.can_change_name(session_member, session_member.session)
  end
  def validate(_, _), do: {:ok}

  @spec update_member(Integer.t, Map.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def update_member(id, params) do
    session_member =
      Repo.get_by!(SessionMember, id: id)
    |> Repo.preload([:session])

    case validate(session_member, params) do
      {:ok} ->
        SessionMember.changeset(session_member, params)
        |> update_member
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec update_emotion(Integer) :: Map.t
  def update_emotion(message_id) do
    message =  Repo.get_by!(Message, id: message_id) |> Repo.preload([:session_member, :session_topic])
    params = %{"avatarData" => %{"face"=> message.emotion}}
    update_session_topic_context(message.session_member, message.session_topic.id, params)
  end

  @spec update_has_messages(Integer.t, Integer.t, Boolean.t) :: Map.t
  def update_has_messages(session_member_id, session_topic_id, true) do
    session_member = Repo.get_by!(SessionMember, id: session_member_id)
    case get_in(session_member.sessionTopicContext, [Integer.to_string(session_topic_id), "hasMessages"]) do
      true ->
        :ok
      _ ->
        case update_session_topic_context(session_member, session_topic_id, %{"hasMessages" => true}) do
          {:ok, session_member_updated} ->
            update_current_member(session_member_updated)
          {:error, _} ->
            :ok
        end
    end
  end 
  def update_has_messages(session_member_id, session_topic_id, false) do
    session_member = Repo.get_by!(SessionMember, id: session_member_id)
    case get_in(session_member.sessionTopicContext, [Integer.to_string(session_topic_id), "hasMessages"]) do
      false ->
        :ok
      _ ->
        case Repo.one(from(m in Message, where: m.sessionMemberId == ^session_member.id, where: m.sessionTopicId == ^session_topic_id, select: true, limit: 1)) do
          true -> 
            :ok
          nil -> 
            case update_session_topic_context(session_member, session_topic_id, %{"hasMessages" => false}) do
              {:ok, session_member_updated} ->
                update_current_member(session_member_updated)
              {:error, _} ->
                :ok
            end
        end
    end
  end 

  defp update_current_member(session_member) do
    {:ok, permissions_map} = PermissionsBuilder.session_member_permissions(session_member.id)
    Endpoint.broadcast!("sessions:#{session_member.sessionId}", "self_info", SessionMembersView.render("current_member.json", member: session_member, permissions_map: permissions_map))
    :ok
  end

  @spec update_session_topic_context(%SessionMember{}, Integer, Map.t) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def update_session_topic_context(session_member, session_topic_id, params) do
    session_topic_context = merge_session_topic_context(session_member.sessionTopicContext, params, session_topic_id)
    SessionMember.changeset(session_member, %{sessionTopicContext: session_topic_context})
    |> update_member
  end

  @spec update_current_topic(Integer, Integer) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def update_current_topic(session_member_id, session_topic_id) do
    session_member =  Repo.get_by!(SessionMember, id: session_member_id)
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    current_topic = %{"id" => session_topic.id, "name" => session_topic.name, "date" => to_string(Timex.now) }
    SessionMember.changeset(session_member, %{currentTopic: current_topic})
    |> update_member
  end

  @spec clean_current_topic(Integer) :: {:ok, %SessionMember{}} | {:error, Ecto.Changeset.t}
  def clean_current_topic(session_member_id) do
    session_member =  Repo.get_by!(SessionMember, id: session_member_id)
    current_topic = %{"id" => nil, "name" => nil, "date" => nil }
    SessionMember.changeset(session_member, %{currentTopic: current_topic})
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
        order_by: sm.id,
        preload: [:account_user]
    result = Repo.all(query)
    {:ok, group_by_role(result)}
  end

  @spec group_by_role(List.t) :: Map.t
  def group_by_role(members) do
    Phoenix.View.render(SessionMembersView, "group_by_role.json", %{ members: members})
  end

  @spec facilitator(Integer.t) :: {:ok, Map.t}
  def facilitator(session_id) do
    query =
      from sm in SessionMember,
        where: sm.sessionId == ^session_id,
        where: sm.role == ^"facilitator"
    result = Repo.one(query)
    {:ok, result}
  end
end
