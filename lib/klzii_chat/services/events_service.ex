defmodule KlziiChat.Services.EventsService do
  alias KlziiChat.{Repo, Event, EventView, SessionMember}
  import Ecto
  import Ecto.Query

  def create_message(session_member_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    changeset = build_assoc(
      session_member, :events,
      tag: "message",
      sessionId: session_member.sessionId,
      event: params,
      topicId: 1
    )
    create(changeset)
  end

  def update_object(session_member_id, topic_id, params) do
    Repo.get_by!(Event, uid: params["id"])
      |> Ecto.Changeset.change(event: params)
      |> update
  end

  def update(changeset) do
    case Repo.update changeset do
      {:ok, event} ->
        event = event |> Repo.preload(:session_member)
        {:ok, Phoenix.View.render(EventView, "event.json", %{event: event} )}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def star(id) do
    event = Repo.get_by!(Event, id: id)
    Ecto.Changeset.change(event, star: !event.star)
      |> update
  end

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

  # TODO need to move in whiteboard service!
  def deleteAll(session_member_id, topicId, params) do
    Enum.map(params["objects"], &(&1["id"])) |> deleteByUids
  end

  def deleteById(id) do
    result =
      Repo.get_by!(Event, id: id)
      |> Repo.delete
    case result do
      {_count, _model}   -> # Deleted with success
        {:ok}
      {:error, error} -> # Something went wrong
        {:error, error}
    end
  end

  # TODO need to move in whiteboard service!
  def deleteByUids(ids) do
    query = from(e in Event, where: e.uid in ^ids)

    case Repo.delete_all(query) do
      {_count, _model}        -> # Deleted with success
        {:ok}
      {:error, changeset} -> # Something went wrong
        {:error, changeset}
    end
  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        event = event |> Repo.preload(:session_member)
        {:ok, Phoenix.View.render(EventView, "event.json", %{event: event} )}
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
