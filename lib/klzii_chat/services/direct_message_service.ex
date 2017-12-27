defmodule KlziiChat.Services.DirectMessageService do
  alias KlziiChat.{ Repo, Session, SessionMember, DirectMessage }
  alias KlziiChat.Services.Permissions.DirectMessage, as: DirectMessagePermissions
  alias KlziiChat.Helpers.MapHelper
  import Ecto
  import Ecto.Query


  @spec validations(boolean) :: {:ok} | {:error, String.t}
  def validations(has_permission) do
    with {:ok} <- has_permission,
    do:  {:ok}
  end

  @spec create_message(Integer.t, Map.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def create_message(session_id, %{ "senderId" => current_member_id, "recieverId" => other_member_id, "text" => text }) do
    session = Repo.get!(Session, session_id)
    current_member = Repo.get!(SessionMember, current_member_id) |> Repo.preload(:account_user)
    other_member = Repo.get!(SessionMember, other_member_id) |> Repo.preload(:account_user)

    DirectMessagePermissions.can_write(current_member, other_member)
    |> validations
    |> case do
        {:ok} ->
          build_assoc(session, :direct_messages)
          |> DirectMessage.changeset(%{senderId: current_member_id, recieverId: other_member_id, text: text})
          |> Repo.insert
        {:error, reason} ->
          {:error, reason}
      end
  end

  @spec get_all_direct_messages(Integer.t, Integer.t, Integer.t) :: List.t
  def get_all_direct_messages(current_member_id, other_member_id, page) do
    current_member = Repo.get!(SessionMember, current_member_id) |> Repo.preload(:account_user)
    other_member = Repo.get!(SessionMember, other_member_id) |> Repo.preload(:account_user)
    limit = per_page()
    offset = page * limit

    Repo.all(from dm in DirectMessage,
      where:
        (dm.senderId == ^current_member.id and dm.recieverId == ^other_member.id) or
        (dm.senderId == ^other_member.id and dm.recieverId == ^current_member.id),
      order_by: [asc: dm.id],
      limit: ^limit,
      offset: ^offset
    )
    |> group_by_read(current_member_id)
  end

  @spec set_all_messages_read(Integer.t, Integer.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def set_all_messages_read(current_member_id, other_member_id) do
    current_member = Repo.get!(SessionMember, current_member_id) |> Repo.preload(:account_user)
    other_member = Repo.get!(SessionMember, other_member_id) |> Repo.preload(:account_user)

    (from dm in DirectMessage, where: dm.recieverId == ^current_member.id and dm.senderId == ^other_member.id and is_nil(dm.readAt))
    |> Repo.update_all(set: [readAt: Timex.now])
    :ok
  end

  @spec get_unread_count(Integer.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def get_unread_count(current_member_id) do
    current_member = Repo.get!(SessionMember, current_member_id) |> Repo.preload(:account_user)

    Repo.all(from dm in DirectMessage,
      where: dm.recieverId == ^current_member.id and is_nil(dm.readAt),
      group_by: dm.senderId,
      select: { dm.senderId, count(dm.id) }
    )
    |> MapHelper.key_to_string()
  end

  @spec get_last_messages(Integer.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def get_last_messages(current_member_id) do
    current_member = Repo.get!(SessionMember, current_member_id) |> Repo.preload(:account_user)

    recieved = Repo.all(from dm in DirectMessage,
      where: dm.sessionId == ^current_member.sessionId and dm.senderId != ^current_member.id,
      distinct: dm.senderId,
      order_by: [desc: dm.id],
      select: %{ senderId: dm.senderId, text: dm.text, createdAt: dm.createdAt }
    )
    |> Enum.reduce(%{}, fn (map, acc) ->
      new_map = %{ to_string(map.senderId) => %{ createdAt: map.createdAt, text: map.text } }
      Map.merge(acc, new_map)
    end)

    sent = Repo.all(from dm in DirectMessage,
      where: dm.sessionId == ^current_member.sessionId and dm.senderId == ^current_member.id,
      distinct: dm.recieverId,
      order_by: [desc: dm.id],
      select: %{ recieverId: dm.recieverId, text: dm.text, createdAt: dm.createdAt }
    )
    |> Enum.reduce(%{}, fn (map, acc) ->
      new_map = %{ to_string(map.recieverId) => %{ createdAt: map.createdAt, text: map.text } }
      Map.merge(acc, new_map)
    end)

    %{ recieved: recieved, sent: sent }
  end

  def group_by_read(messages, current_member_id) do
    Enum.group_by(messages, &(is_message_read(&1, current_member_id)))
  end

  def is_message_read(message, current_member_id) do
    (message.senderId == current_member_id ||
      (message.recieverId == current_member_id && !is_nil(message.readAt)))
    |> select_key
  end

  def select_key(true), do: "read"
  def select_key(false), do: "unread"
  def per_page(), do: 10
end
