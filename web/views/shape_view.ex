defmodule KlziiChat.ShapeView do
  use KlziiChat.Web, :view
  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{shape: shape}) do
    %{
      id: shape.id,
      event: shape.event,
      time: shape.createdAt,
      uid: shape.uid
    }
  end
end
