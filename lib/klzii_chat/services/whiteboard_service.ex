defmodule KlziiChat.Services.WhiteboardService do
  alias KlziiChat.{Repo, Event, EventView, SessionMember, Vote, Topic}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def history(topic_id, tag) do
    topic = Repo.get!(Topic, topic_id)
    events = Repo.all(
      from e in assoc(topic, :events),
        where: [tag: ^tag],
        where: is_nil(e.replyId),
        order_by: [asc: e.createdAt],
        limit: 200,
      preload: [:session_member]
    )
    {:ok, Phoenix.View.render_many(events, EventView, "whiteboard_event.json")}
  end

  def update(changeset) do
    case Repo.update changeset do
      {:ok, event} ->
        {:ok, build_object_response(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def build_object_response(event) do
    Phoenix.View.render(EventView, "whiteboard_event.json", %{ event: event })
  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, build_object_response(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_object(session_member_id, topic_id, params) do
    Repo.get_by!(Event, uid: params["id"])
    |> Ecto.Changeset.change(event: params)
    |> update
  end


  # TODO need to move in whiteboard service!
  def create_object(session_member_id, topic_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    changeset = build_assoc(
      session_member, :events,
      tag: "object",
      sessionId: session_member.sessionId,
      event: params,
      uid: params["id"],
      topicId: topic_id
    )
    create(changeset)
  end

  def deleteAll(session_member_id, topicId, params) do
    Enum.map(params["objects"], &(&1["id"])) |> deleteByUids
  end

  def deleteByUids(ids) do
    query = from(e in Event, where: e.uid in ^ids)

    case Repo.delete_all(query) do
      {_count, _model}        -> # Deleted with success
        {:ok}
      {:error, changeset} -> # Something went wrong
        {:error, changeset}
    end
  end
end
