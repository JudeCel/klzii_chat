defmodule KlziiChat.ShapeView do
  use KlziiChat.Web, :view
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [to_boolean: 1]
  alias KlziiChat.Services.Permissions.Whiteboard, as: WhiteboardcPermissions

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{shape: shape, member: member}) do
    %{
      id: shape.id,
      event: shape.event,
      time: shape.createdAt,
      uid: shape.uid,
      permissions: %{
        can_edit: WhiteboardcPermissions.can_edit(member, shape) |> to_boolean,
        can_delete: WhiteboardcPermissions.can_delete(member, shape) |> to_boolean
      }
    }
  end
end
