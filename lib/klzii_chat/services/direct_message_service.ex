defmodule KlziiChat.Services.DirectMessageService do
  alias KlziiChat.{Repo, Session, SessionMember, DirectMessage}
  alias KlziiChat.Helpers.IntegerHelper
  import Ecto
  import Ecto.Query

  @spec create_message(Integer.t, Map.t) :: {:ok, Map.t} | {:error, Ecto.Changeset.t}
  def create_message(session_id, %{"senderId" => senderId, "recieverId" => recieverId, "text" => text}) do
    session = Repo.get!(Session, session_id)

    build_assoc(
      session, :direct_messages,
      senderId: IntegerHelper.get_num(senderId),
      recieverId: IntegerHelper.get_num(recieverId),
      text: text
    )
    |> Repo.insert
  end

  @spec get_all_direct_messages(Integer.t, Integer.t) :: List.t
  def get_all_direct_messages(recieverId, senderId) do
    reciever_member = Repo.get!(SessionMember, recieverId)
    sender_member = Repo.get!(SessionMember, senderId)

    Repo.all(from dm in DirectMessage,
      where:
        (dm.senderId == ^reciever_member.id and dm.recieverId == ^sender_member.id) or
        (dm.senderId == ^sender_member.id and dm.recieverId == ^reciever_member.id),
      order_by: [desc: dm.createdAt]
    )
    |> group_by_read(recieverId)
  end

  @spec set_all_messages_read(Integer.t, Integer.t) :: {:ok, Map.t} | {:error, Ecto.Changeset.t}
  def set_all_messages_read(recieverId, senderId) do
    sender_member = Repo.get!(SessionMember, senderId)
    reciever_member = Repo.get!(SessionMember, recieverId)

    from(from dm in DirectMessage,
      where: dm.recieverId == ^reciever_member.id and dm.senderId == ^sender_member.id and is_nil(dm.readAt)
    )
    |> Repo.update_all(set: [readAt: Timex.DateTime.now])
  end

  def group_by_read(messages, member_id) do
    Enum.group_by(messages, &(is_message_read(&1, member_id)))
  end

  def is_message_read(message, member_id) do
    (message.recieverId == member_id && !is_nil(message.readAt))
    |> select_key
  end

  def select_key(true), do: "read"
  def select_key(false), do: "unread"
end
