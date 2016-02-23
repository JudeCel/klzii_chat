defmodule KlziiChat.Services.EventsService do
  alias KlziiChat.{Repo, Event, EventView, SessionMember}
  import Ecto
  import Ecto.Query

  def create_message(session_member_id, params) do
    IO.inspect(params)
    replyId = if params["id"] do
      String.to_integer(params["id"])
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
      topicId: 1
    ) |> create
  end

  def deleteById(id) do
    result = Repo.get_by!(Event, id: id)
    case result do
      {_count, _model}   -> # Deleted with success
        {:ok}
      {:error, error} -> # Something went wrong
        {:error, error}
    end
  end


  def update(changeset) do
    case Repo.update changeset do
      {:ok, event} ->
        {:ok, build_message_response(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def build_message_response(event) do
    if is_nil(event.replyId) do
      event = Repo.get_by!(Event, id: event.id)
    else
      event = Repo.get_by!(Event, id: event.replyId)
    end

    event = Repo.preload(event, [:session_member, replies: [:replies, :session_member] ])
    Phoenix.View.render(EventView, "event.json", %{ event: event })

  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, build_message_response(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_message(id, body) do
    event = Repo.get_by!(Event, id: id)
    Ecto.Changeset.change(event, event: %{body: body})
    |> update
  end

  def star(id) do
    event = Repo.get_by!(Event, id: id)
    Ecto.Changeset.change(event, star: !event.star)
    |> update
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
      topicId: 1
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
