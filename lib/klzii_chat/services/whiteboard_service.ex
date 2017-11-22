defmodule KlziiChat.Services.WhiteboardService do
  alias KlziiChat.{Repo, Shape, ShapeView, SessionMember, SessionTopic, Session}
  alias KlziiChat.Services.Permissions.Whiteboard, as: WhiteboardPermissions
  alias KlziiChat.Queries.Shapes, as: ShapesQueries
  import Ecto.Query, only: [from: 2, preload: 2]

  def history(session_topic_id, session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload(:account_user)

    resp =
      ShapesQueries.base_query(%{sessionTopicId: session_topic_id})
      |> preload(:session_member)
      |> Repo.all
      |>  Enum.map(fn shape ->
            ShapeView.render("show.json", %{shape: shape, member: session_member})
          end)

    {:ok, resp}
  end

  def update(changeset) do
    case Repo.update changeset, preload: [:session_member] do
      {:ok, shape} ->
        {:ok, Repo.preload(shape, [:session_member])}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create(changeset) do
    case Repo.insert(changeset) do
      {:ok, shape} ->
        {:ok, Repo.preload(shape, [:session_member])}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_object(session_member_id, _, params) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload(:account_user)
    shape = Repo.get_by!(Shape, uid: params["id"])
    if WhiteboardPermissions.can_edit(session_member, shape) do
      Shape.changeset(shape, %{event: params})
      |> update
    else
      {:error, %{permissions: "Action not allowed!"}}
    end
  end

  def create_object(session_member_id, session_topic_id, params) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload(:account_user)
    session = Repo.get!(Session, session_member.sessionId)
      |> Repo.preload([:session_type])
    {:ok, preference} = KlziiChat.Services.Permissions.Builder.get_subscription_preference_session(session.id)
    if WhiteboardPermissions.can_new_shape(session_member, session, preference) do
      changeset = %{
        sessionMemberId: session_member.id,
        sessionId: session_member.sessionId,
        event: params,
        uid: params["id"],
        sessionTopicId: session_topic_id
      }
      Shape.changeset(%Shape{}, changeset)
      |> create()
    else
      {:error, %{permissions: "Action not allowed!"}}
    end
  end

  def deleteAll(session_member_id, session_topic_id) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload(:account_user)
    session_topic = Repo.get!(SessionTopic, session_topic_id)
    {_count, shapes}  =
      ShapesQueries.find_shapes_for_delete(session_member, session_topic)
      |> Repo.delete_all(returning: true)

      {:ok, Enum.map(shapes, fn(e) -> %{uid: e.uid} end)}
  end

  def deleteByUid(session_member_id, id) do
    session_member = Repo.get!(SessionMember, session_member_id) |> Repo.preload(:account_user)
    query = from(e in Shape, where: e.uid == ^id)
    shape = Repo.one(query)

    if WhiteboardPermissions.can_delete(session_member, shape) do
      Repo.delete(shape)
    else
      {:error, %{permissions: "Action not allowed!"}}
    end
  end
end
