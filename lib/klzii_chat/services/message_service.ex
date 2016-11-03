defmodule KlziiChat.Services.MessageService do
  alias KlziiChat.{Repo, Message, UnreadMessage, MessageView, SessionMember, Vote, SessionTopic}
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  alias KlziiChat.Helpers.IntegerHelper
  import Ecto
  import Ecto.Query

  @spec history(Integer.t, Map.t) :: {:ok, List.t }
  def history(session_topic_id, session_member) do
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    all_messages = Repo.all(
      from e in assoc(session_topic, :messages),
        where: is_nil(e.replyId),
        order_by: [asc: e.createdAt],
        limit: 200
      )
    {:ok, messages} = preload_dependencies(all_messages, session_member.id)
    resp = Enum.map(messages, fn message ->
      MessageView.render("show.json", %{message: message, member: session_member})
    end)
    {:ok, resp}
  end

  @spec create_message(Map.t, Integer.t, Map.t) :: {:ok, Map.t }
  def create_message(session_member, session_topic_id, %{"replyId" => replyId, "emotion" => emotion, "body" => body}) do

    case MessagePermissions.can_new_message(session_member) do
      {:ok} ->
        {reply_message, reply_level} = reply_message_data(replyId)
        session_member = Repo.get!(SessionMember, session_member.id)
        map = %{
          replyId: IntegerHelper.get_num(replyId),
          sessionId: session_member.sessionId,
          body: (reply_message <> body),
          emotion: IntegerHelper.get_num(emotion),
          sessionTopicId: IntegerHelper.get_num(session_topic_id),
          replyLevel: reply_level
        }
        build_assoc(session_member, :messages)
        |> Message.changeset(map)
        |> create
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec create_message(Map.t, Integer.t, Map.t) :: {:ok, Map.t }
  def create_message(session_member, session_topic_id, %{"emotion" => emotion, "body" => body}) do
    case MessagePermissions.can_new_message(session_member) do
      {:ok} ->
        session_member = Repo.get!(SessionMember, session_member.id)
        map = %{sessionId: session_member.sessionId,
          body: body,
          emotion: IntegerHelper.get_num(emotion),
          sessionTopicId: IntegerHelper.get_num(session_topic_id),
          replyLevel: 0}
        build_assoc(session_member, :messages)
        |> Message.changeset(map)
        |> create
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec deleteById(Map.t, Integer.t) :: {:ok, %{ id: Integer.t, replyId: Integer.t } } | {:error, String.t}
  def deleteById(session_member, id) do
    result = Repo.get_by!(Message, id: id)
    case MessagePermissions.can_delete(session_member, result) do
      {:ok} ->
        case Repo.delete!(result) do
          {:error, error} ->
            {:error, error}
          event ->
            {:ok, %{ id: event.id, replyId: event.replyId } }
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec preload_dependencies(%Message{} | [%Message{}],  Integer.t) :: %Message{} | [%Message{}]
  def preload_dependencies(message, session_member_id) do
    unread_messages_query = from(um in UnreadMessage, where: um.sessionMemberId == ^session_member_id)
    replies_replies_query = from(rpl in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, :replies, unread_messages: ^unread_messages_query])
    replies_query = from(st in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, unread_messages: ^unread_messages_query, replies: ^replies_replies_query])
    {:ok, Repo.preload(message, [:session_member, :votes, unread_messages: unread_messages_query, replies: replies_query])}
  end

  @spec create(%Message{}) :: %Message{}
  def create(changeset) do
    with {:ok, message} <- Repo.insert(changeset),
         {:ok, _} <- KlziiChat.Services.SessionMembersService.update_emotion(message.id),
    do: preload_dependencies(message, 0)
  end

  @spec get_message(Integer.t) :: %Message{}
  def get_message(id) do
    Repo.get_by!(Message, id: id)
  end

  @spec update_message(Integer.t, String.t, String.t, Map.t) :: %Message{} | {:error, String.t}
  def update_message(id, body, emotion, session_member) do
    event = Repo.get_by!(Message, id: id)
    case MessagePermissions.can_edit(session_member, event) do
      {:ok} ->
        Ecto.Changeset.change(event, body: body, emotion: IntegerHelper.get_num(emotion) )
          |> update_msg
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec update_msg(%Message{}) :: {:ok, %Message{}} | {:error, Ecto.Changeset.t}
  def update_msg(changeset) do
    case Repo.update(changeset) do
      {:ok, message} ->
         preload_dependencies(message, 0)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec star(Integer.t, Map.t) :: %Message{} | {:error, String.t}
  def star(id, session_member) do
    case MessagePermissions.can_star(session_member) do
      {:ok} ->
        event = Repo.get_by!(Message, id: id)
        Ecto.Changeset.change(event, star: !event.star)
          |> update_msg
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec thumbs_up(Integer.t, Map.t) :: Map.t | {:error, String.t}
  def thumbs_up(id, session_member) do
    message = Repo.get_by!(Message, id: id)
    case MessagePermissions.can_vote(session_member, message) do
      {:ok} ->
        case Repo.get_by(Vote, messageId: id, sessionMemberId: session_member.id) do
          nil ->
            changeset = Vote.changeset(%Vote{}, %{sessionMemberId: session_member.id, messageId: id})
            case Repo.insert(changeset) do
              {:ok, _vote} ->
                preload_dependencies(message, 0)
              {:error, changeset} ->
                {:error, changeset}
            end
          vote ->
            case Repo.delete!(vote) do
              {:error, changeset} ->
                {:error, changeset}
              _ ->
                preload_dependencies(message, 0)
            end
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec reply_message_data(Integer.t) :: String.t
  defp reply_message_data(replyId) do
    Repo.one(from m in Message, where: m.id == ^replyId, preload: [:session_member])
      |> case  do
        nil ->
          {"", 0}
        message ->
          {"@" <> message.session_member.username <> " ", message.replyLevel + 1}
      end
  end
end
