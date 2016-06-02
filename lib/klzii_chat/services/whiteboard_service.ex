defmodule KlziiChat.Services.WhiteboardService do
  alias KlziiChat.{Repo, Shape, ShapeView, SessionMember, SessionTopic}
  alias KlziiChat.Services.Permissions.Whiteboard, as: WhiteboardPermissions
  alias KlziiChat.Queries.Shapes, as: ShapesQueries
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

  def update_object(session_member_id, _, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    shape = Repo.get_by!(Shape, uid: params["id"])

    if WhiteboardPermissions.can_edit(session_member, shape) do
      Ecto.Changeset.change(shape, event: params)
      |> update
    else
      {:error, "Action not allowed!"}
    end
  end

  def create_object(session_member_id, session_topic_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id)
    if WhiteboardPermissions.can_new_shape(session_member) do
      changeset = build_assoc(
        session_member, :shapes,
        sessionId: session_member.sessionId,
        event: params,
        uid: params["id"],
        sessionTopicId: session_topic_id
      )
      create(changeset)
    else
      {:error, "Action not allowed!"}
    end
  end

  def deleteAll(session_member_id, session_topic_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    ShapesQueries.find_shapes_for_delete(session_member, session_topic) |> Repo.delete_all
    history(session_topic.id, session_member.id)
  end

  def deleteByUid(session_member_id, id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    query = from(e in Shape, where: e.uid == ^id)
    shape = Repo.one(query)

    if WhiteboardPermissions.can_delete(session_member, shape) do
      Repo.delete(shape)
    else
      {:error, "Action not allowed!"}
    end
  end
end
