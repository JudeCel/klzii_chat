defmodule KlziiChat.Services.EventsService do
  alias KlziiChat.{Repo, Event, EventView, SessionMember, Vote, Topic}
  import Ecto
  import Ecto.Query

  def history(topic_id, tag, session_member_id) do
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
      EventView.render("event.json", %{event: event, member_id: session_member_id})
    end)
    {:ok, resp}
  end

  def create_message(session_member_id, topic_id, params) do
    replyId = if params["replyId"] do
      String.to_integer(params["replyId"])
    else
      nil
    end
    session_member = Repo.get!(SessionMember, session_member_id)
    build_assoc(
      session_member, :events,
      tag: "message",
      replyId: replyId,
      sessionId: session_member.sessionId,
      event: params,
      topicId: replyId
    ) |> create(session_member_id)
  end

  def deleteById(id) do
    result = Repo.get_by!(Event, id: id)
    case Repo.delete!(result) do
      {:error, error} -> # Something went wrong
        {:error, error}
      event   -> # Deleted with success
        {:ok, %{ id: event.id, replyId: event.replyId } }
    end
  end



  def build_message_response(event, session_member_id) do
    event = Repo.preload(event, [:session_member, :votes, replies: [:replies, :session_member, :votes] ])
    EventView.render("event.json", %{event: event, member_id: session_member_id})

  end

  def create(changeset, session_member_id) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, build_message_response(event, session_member_id)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_message(id, body, session_member_id) do
    event = Repo.get_by!(Event, id: id)
    Ecto.Changeset.change(event, event: %{ body: body })
      |> update_msg(session_member_id)
  end

  def update_msg(changeset, session_member_id) do
    case Repo.update(changeset) do
      {:ok, event} ->
        {:ok, build_message_response(event, session_member_id)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def star(id, session_member_id) do
    event = Repo.get_by!(Event, id: id)
    Ecto.Changeset.change(event, star: !event.star)
      |> update_msg(session_member_id)
  end

  def thumbs_up(id, session_member_id) do
    event = Repo.get_by!(Event, id: id)

    case Repo.get_by(Vote, eventId: id) do
      nil ->
        changeset = Vote.changeset(%Vote{}, %{sessionMemberId: session_member_id, eventId: id})
        case Repo.insert(changeset) do
          {:ok, _vote} ->
            {:ok, build_message_response(event, session_member_id)}
          {:error, changeset} ->
            {:error, changeset}
        end
      vote ->
        case Repo.delete!(vote) do
          vote ->
            {:ok, build_message_response(event, session_member_id)}
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
end
