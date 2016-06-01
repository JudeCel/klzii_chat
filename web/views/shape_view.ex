defmodule KlziiChat.ShapeView do
  use KlziiChat.Web, :view
  alias KlziiChat.Services.Permissions.Whiteboard, as: WhiteboardcPermissions

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{shape: shape, member: member}) do
    %{
      id: shape.id,
      event: shape.event,
      time: shape.createdAt,
      uid: shape.uid,
      permissions: %{
        can_edit: WhiteboardcPermissions.can_edit(member, shape),
        can_delete: WhiteboardcPermissions.can_delete(member, shape)
      }
    }
  end
end
