defmodule KlziiChat.Services.MessageService do
  alias KlziiChat.{Repo, Message, MessageView, SessionMember, Vote, Topic}
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  import Ecto
  import Ecto.Query

  @spec history(Integer.t, Map.t) :: {:ok, List.t }
  def history(topic_id, session_member) do
    topic = Repo.get!(Topic, topic_id)
    messages = Repo.all(
      from e in assoc(topic, :messages),
        where: is_nil(e.replyId),
        order_by: [asc: e.createdAt],
        limit: 200,
      preload: [:session_member, :votes, replies: [:replies, :session_member, :votes] ]
    )
    resp = Enum.map(messages, fn message ->
      MessageView.render("show.json", %{message: message, member: session_member})
    end)
    {:ok, resp}
  end

  @spec create_message(Map.t, Integer.t, Map.t) :: {:ok, Map.t }
  def create_message(session_member, topic_id, %{"replyId" => replyId, "emotion" => emotion, "body" => body}) do
    if MessagePermissions.can_new_message(session_member) do
      replyId = get_integer_value(replyId)
      replay_message = replay_message_prefix(replyId)

      session_member = Repo.get!(SessionMember, session_member.id)
      build_assoc(
        session_member, :messages,
        replyId: replyId,
        sessionId: session_member.sessionId,
        body: (replay_message <> body),
        emotion: get_integer_value(emotion),
        topicId: get_integer_value(topic_id)
      ) |> create
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec create_message(Map.t, Integer.t, Map.t) :: {:ok, Map.t }
  def create_message(session_member, topic_id, %{"emotion" => emotion, "body" => body}) do
    if MessagePermissions.can_new_message(session_member) do
      session_member = Repo.get!(SessionMember, session_member.id)
      build_assoc(
        session_member, :messages,
        sessionId: session_member.sessionId,
        body: body,
        emotion: get_integer_value(emotion),
        topicId: get_integer_value(topic_id)
      ) |> create
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec deleteById(Map.t, Integer.t) :: {:ok, %{ id: Integer.t, replyId: Integer.t } } | {:error, String.t}
  def deleteById(session_member, id) do
    result = Repo.get_by!(Message, id: id)
    if MessagePermissions.can_delete(session_member, result) do
      case Repo.delete!(result) do
        {:error, error} -> # Something went wrong
          {:error, error}
        event   -> # Deleted with success
          {:ok, %{ id: event.id, replyId: event.replyId } }
      end
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec preload_dependencies(%Message{}) :: %Message{}
  def preload_dependencies(event) do
    Repo.preload(event, [:session_member, :votes, replies: [:replies, :session_member, :votes] ])
  end

  @spec create(%Message{}) :: %Message{}
  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, preload_dependencies(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec update_message(Integer.t, String.t, Map.t) :: %Message{} | {:error, String.t}
  def update_message(id, body, session_member) do
    event = Repo.get_by!(Message, id: id)
    if MessagePermissions.can_edit(session_member, event) do
      Ecto.Changeset.change(event, body: body )
        |> update_msg
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec update_msg(%Message{}) :: %Message{}
  def update_msg(changeset) do
    case Repo.update(changeset) do
      {:ok, event} ->
        {:ok, preload_dependencies(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec star(Integer.t, Map.t) :: %Message{} | {:error, String.t}
  def star(id, session_member) do
    if MessagePermissions.can_star(session_member) do
      event = Repo.get_by!(Message, id: id)
      Ecto.Changeset.change(event, star: !event.star)
        |> update_msg
    else
      {:error, "Action not allowed!"}
    end
  end

  @spec thumbs_up(Integer.t, Map.t) :: Map.t | {:error, String.t}
  def thumbs_up(id, session_member) do
    if MessagePermissions.can_vote(session_member) do
      event = Repo.get_by!(Message, id: id)
      case Repo.get_by(Vote, messageId: id, sessionMemberId: session_member.id) do
        nil ->
          changeset = Vote.changeset(%Vote{}, %{sessionMemberId: session_member.id, messageId: id})
          case Repo.insert(changeset) do
            {:ok, _vote} ->
              {:ok, preload_dependencies(event)}
            {:error, changeset} ->
              {:error, changeset}
          end
        vote ->
          case Repo.delete!(vote) do
            {:error, changeset} ->
              {:error, changeset}
            _ ->
              {:ok, preload_dependencies(event)}
          end
      end
    else
      {:error, "Action not allowed!"}
    end
  end


  defp replay_message_prefix(replyId) do
    Repo.one(from m in Message, where: m.id == ^replyId, preload: [:session_member])
      |> case  do
        nil ->
          ""
        message ->
          "@" <> message.session_member.username <> " "
      end
  end

  defp get_integer_value(value) do
    if is_integer(value) do
      value
    else
      String.to_integer(value)
    end
  end
end
