defmodule KlziiChat.Services.WhiteboardService do
  alias KlziiChat.{Repo, Shape, ShapeView, SessionMember, SessionTopic}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def history(session_topic_id, session_member_id) do
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    session_member = Repo.get!(SessionMember, session_member_id)
    shapes = Repo.all(
      from e in assoc(session_topic, :shapes),
      preload: [:session_member]
    )
    resp = Enum.map(shapes, fn shape ->
      ShapeView.render("show.json", %{shape: shape, member: session_member})
    end)
    {:ok, resp}
  end

  def update(changeset) do
    case Repo.update changeset do
      {:ok, shape} ->
        {:ok, shape}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, shape} ->
        {:ok, shape}
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

  def deleteAll(session_topic_id) do
    session_topic = Repo.get!(SessionTopic, session_topic_id)
      from(e in assoc(session_topic, :shapes)
    )|> Repo.delete_all
    # Enum.map(params["objects"], &(&1["id"])) |> deleteByUids
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
