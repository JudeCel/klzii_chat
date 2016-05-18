defmodule KlziiChat.Services.WhiteboardService do
  alias KlziiChat.{Repo, Shape, ShapeView, SessionMember, SessionTopic}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def history(topic_id, _) do
    session_topic = Repo.get!(SessionTopic, topic_id)
    shapes = Repo.all(
      from e in assoc(session_topic, :shapes),
      preload: [:session_member]
    )
    {:ok, Phoenix.View.render_many(shapes, ShapeView, "show.json")}
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
    Phoenix.View.render_many(event, ShapeView, "show.json")
  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, build_object_response(event)}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_object(_session_member_id, _, params) do
    Repo.get_by!(Shape, uid: params["id"])
    |> Ecto.Changeset.change(event: params)
    |> update
  end

  def create_object(session_member_id, session_topic_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    changeset = build_assoc(
      session_member, :shapes,
      sessionId: session_member.sessionId,
      event: params,
      uid: params["id"],
      sessionTopicId: session_topic_id
    )
    create(changeset)
  end

  def deleteAll(_session_member_id, _, params) do
    Enum.map(params["objects"], &(&1["id"])) |> deleteByUids
  end

  def deleteByUids(ids) do
    query = from(e in Shape, where: e.uid in ^ids)

    case Repo.delete_all(query) do
      {:error, changeset} ->
        {:error, changeset}
      {_count, _model} -> # Deleted with success
        {:ok}
    end
  end
end
