defmodule KlziiChat.Services.DirectMessageService do
  alias KlziiChat.{ Repo, Session, SessionMember, DirectMessage }
  import Ecto
  import Ecto.Query

  @spec create_message(Integer.t, Map.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def create_message(session_id, %{ "senderId" => senderId, "recieverId" => recieverId, "text" => text }) do
    session = Repo.get!(Session, session_id)

    build_assoc(
      session, :direct_messages,
      senderId: senderId,
      recieverId: recieverId,
      text: text
    )
    |> Repo.insert
  end

  @spec get_all_direct_messages(Integer.t, Integer.t) :: List.t
  def get_all_direct_messages(current_member_id, other_member_id) do
    current_member = Repo.get!(SessionMember, current_member_id)
    other_member = Repo.get!(SessionMember, other_member_id)

    Repo.all(from dm in DirectMessage,
      where:
        (dm.senderId == ^current_member.id and dm.recieverId == ^other_member.id) or
        (dm.senderId == ^other_member.id and dm.recieverId == ^current_member.id),
      order_by: [desc: dm.createdAt]
    )
    |> group_by_read(current_member_id)
  end

  @spec set_all_messages_read(Integer.t, Integer.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def set_all_messages_read(current_member_id, other_member_id) do
    current_member = Repo.get!(SessionMember, current_member_id)
    other_member = Repo.get!(SessionMember, other_member_id)

    (from dm in DirectMessage, where: dm.recieverId == ^current_member.id and dm.senderId == ^other_member.id and is_nil(dm.readAt))
    |> Repo.update_all(set: [readAt: Timex.DateTime.now])
    :ok
  end

  @spec get_unread_count(Integer.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def get_unread_count(current_member_id) do
    current_member = Repo.get!(SessionMember, current_member_id)

    Repo.all(from dm in DirectMessage,
      where: dm.recieverId == ^current_member.id and is_nil(dm.readAt),
      group_by: dm.senderId,
      select: { dm.senderId, count(dm.id) }
    )
    |> map_key_to_string()
  end

  @spec get_last_messages(Integer.t) :: { :ok, Map.t } | { :error, Ecto.Changeset.t }
  def get_last_messages(current_member_id) do
    current_member = Repo.get!(SessionMember, current_member_id)

    Repo.all(from dm in DirectMessage,
      where: dm.sessionId == ^current_member.sessionId and dm.senderId != ^current_member.id,
      distinct: dm.senderId,
      order_by: [desc: dm.id],
      select: { dm.senderId, dm.text }
    )
    |> map_key_to_string()
  end

  def map_key_to_string(data) do
    Enum.reduce(data, %{}, fn { key, value }, acc ->
      Map.put(acc, to_string(key), value)
    end)
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
end
