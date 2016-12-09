defmodule KlziiChat.ShapeView do
  use KlziiChat.Web, :view
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [to_boolean: 1]
  alias KlziiChat.Services.Permissions.Whiteboard, as: WhiteboardcPermissions

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{shape: shape, member: member}) do
    shape_map = render("shape.json", %{shape: shape})
    permissions = %{
      can_edit: WhiteboardcPermissions.can_edit(member, shape) |> to_boolean,
      can_delete: WhiteboardcPermissions.can_delete(member, shape) |> to_boolean
    }
    Map.put(shape_map, :permissions, permissions)
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("shape.json", %{shape: shape}) do
    %{
      id: shape.id,
      event: render("event.json", %{shape: shape}),
      time: shape.createdAt,
      uid: shape.uid,
      sessionTopicId: shape.sessionTopicId
    }
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("report.json", %{shape: shape}) do
    render("shape.json", %{shape: shape})
  end

  @spec render(String.t, Map.t) :: Map.t
  def render("event.json", %{shape: shape}) do
    shape.event
  end
end
