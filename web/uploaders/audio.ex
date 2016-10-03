defmodule KlziiChat.Uploaders.Audio do
  use KlziiChat.Uploaders.StoreDefinition

  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original]
  def versions, do: @versions
  @acl :public_read

  def allowed_extensions() do
    ~w(.mp3 )
  end

  # Whitelist file extensions:
  def validate({file, _}) do
    allowed_extensions |> Enum.member?(Path.extname(file.file_name))
  end
end
