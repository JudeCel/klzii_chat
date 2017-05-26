defmodule KlziiChat.Uploaders.Video do
  use Arc.Definition
  use KlziiChat.Uploaders.StoreDefinition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original]
  def versions, do: @versions
  @acl :public_read


  def allowed_extensions() do
    ~w(.mp4 .mpeg )
  end
end
