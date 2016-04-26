defmodule KlziiChat.Services.WhiteboardService do
  alias KlziiChat.{Repo, Shape, ShapeView, SessionMember, Topic}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def history(topic_id) do
    topic = Repo.get!(Topic, topic_id)
    shapes = Repo.all(
      from e in assoc(topic, :shapes),
      preload: [:session_member]
    )
    {:ok, Phoenix.View.render_many(shapes, ShapeView, "show.json")}
  end

  def update(changeset) do
    case Repo.update changeset do
      {:ok, shape} ->
        {:ok, build_object_response(shape)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def build_object_response(shape) do
    Phoenix.View.render_one(shape, ShapeView, "show.json")
  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, shape} ->
        {:ok, build_object_response(shape)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_object(session_member_id, topic_id, params) do
    Repo.get_by!(Shape, uid: params["id"])
    |> Ecto.Changeset.change(event: params)
    |> update
  end


  def create_object(session_member_id, topic_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    changeset = build_assoc(
      session_member, :shapes,
      sessionId: session_member.sessionId,
      event: params,
      uid: params["id"],
      topicId: topic_id
    )
    create(changeset)
  end

  def deleteAll(session_member_id, topicId) do
    topic = Repo.get!(Topic, topicId)
    query = from e in assoc(topic, :shapes)

    case Repo.delete_all(query) do
      {_count, _model}        -> # Deleted with success
        {:ok}
      {:error, changeset} -> # Something went wrong
        {:error, changeset}
    end
  end
#might not need this fuynction
  def deleteByUids(ids) do
    query = from(e in Shape, where: e.uid in ^ids)

    case Repo.delete_all(query) do
      {_count, _model}        -> # Deleted with success
        {:ok}
      {:error, changeset} -> # Something went wrong
        {:error, changeset}
    end
  end
end
