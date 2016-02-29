defmodule KlziiChat.Services.EventsService do
  alias KlziiChat.{Repo, Event, EventView, SessionMember, Vote, Topic}
  alias KlziiChat.Services.Permissions
  import Ecto
  import Ecto.Query

  @spec set_permissions(Map.t, Map.t) :: Map.t
  def set_permissions(event, session_member) do
    permissions = %{
      can_edit: Permissions.can_edit(event, session_member),
      can_delete: Permissions.can_delete(event, session_member),
      can_star: Permissions.can_star(session_member),
      can_vote: Permissions.can_vote(session_member),
      can_reply: Permissions.can_reply(session_member)
    }
    Map.merge(event, %{permissions: permissions})
  end

  @spec has_voted(Map.t, Integer.t) :: Map.t
  def has_voted(event, session_member_id) do
    Map.merge(event,
      %{has_voted:  Enum.any?(event.votes_ids, fn id ->
        id == session_member_id
      end)
    })
  end

  @spec set_individual_context(Map.t, Map.t) :: Map.t
  def set_individual_context(event, session_member) do
    set_permissions(event, session_member)
      |> has_voted(session_member.id)
  end

  @spec history(Integer.t, String.t, Map.t) :: {:ok, List.t }
  def history(topic_id, tag, session_member) do
    topic = Repo.get!(Topic, topic_id)
    events = Repo.all(
      from e in assoc(topic, :events),
        where: [tag: ^tag],
        where: is_nil(e.replyId),
        order_by: [asc: e.createdAt],
        limit: 200,
      preload: [:session_member, :votes, replies: [:replies, :session_member, :votes] ]
    )
    resp = Enum.map(events, fn event ->
      EventView.render("event.json", %{event: event, member: session_member})
        |> set_individual_context(session_member)
    end)
    {:ok, resp}
  end

  @spec create_message(Map.t, Integer.t, Map.t) :: {:ok, Map.t }
  def create_message(session_member, topic_id, params) do
    replyId =
      case params["replyId"] do
        nil ->
          nil
        id ->
          String.to_integer(id)
      end

    session_member = Repo.get!(SessionMember, session_member.id)
    build_assoc(
      session_member, :events,
      tag: "message",
      replyId: replyId,
      sessionId: session_member.sessionId,
      event: params,
      topicId: topic_id
    ) |> create(session_member)
  end

  @spec deleteById(Integer.t) :: {:ok, %{ id: Integer.t, replyId: Integer.t } }
  def deleteById(id) do
    result = Repo.get_by!(Event, id: id)
    case Repo.delete!(result) do
      {:error, error} -> # Something went wrong
        {:error, error}
      event   -> # Deleted with success
        {:ok, %{ id: event.id, replyId: event.replyId } }
    end
  end

  @spec build_message_response(%Event{}, Map.t) :: Map.t
  def build_message_response(event, session_member) do
    event = Repo.preload(event, [:session_member, :votes, replies: [:replies, :session_member, :votes] ])
    EventView.render("event.json", %{event: event, member: session_member})
  end

  @spec create(%Event{}, Map.t) :: Map.t
  def create(changeset, session_member) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, build_message_response(event, session_member)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec update_message(Integer.t, String.t, Map.t) :: Map.t
  def update_message(id, body, session_member) do
    event = Repo.get_by!(Event, id: id)
    Ecto.Changeset.change(event, event: %{ body: body })
      |> update_msg(session_member)
  end

  @spec update_msg(%Event{}, Map.t) :: Map.t
  def update_msg(changeset, session_member) do
    case Repo.update(changeset) do
      {:ok, event} ->
        {:ok, build_message_response(event, session_member)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec star(Integer.t, Map.t) :: Map.t
  def star(id, session_member) do
    event = Repo.get_by!(Event, id: id)
    Ecto.Changeset.change(event, star: !event.star)
      |> update_msg(session_member)
  end

  @spec thumbs_up(Integer.t, Map.t) :: Map.t
  def thumbs_up(id, session_member) do
    event = Repo.get_by!(Event, id: id)
    case Repo.get_by(Vote, eventId: id, sessionMemberId: session_member.id) do
      nil ->
        changeset = Vote.changeset(%Vote{}, %{sessionMemberId: session_member.id, eventId: id})
        case Repo.insert(changeset) do
          {:ok, _vote} ->
            {:ok, build_message_response(event, session_member)}
          {:error, changeset} ->
            {:error, changeset}
        end
      vote ->
        case Repo.delete!(vote) do
          vote ->
            {:ok, build_message_response(event, session_member)}
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
end
