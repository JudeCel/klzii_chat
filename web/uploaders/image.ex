defmodule KlziiChat.Uploaders.Image do
  use KlziiChat.Uploaders.StoreDefinition

  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb, :gallery_thumb]
  def versions, do: @versions
  @acl :public_read

  def allowed_extensions() do
    ~w(.gif .png .jpg .jpeg .bmp)
  end

  # Whitelist file extensions:
  def validate({file, _}) do
    allowed_extensions |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250>"}
  end
  def transform(:gallery_thumb, _) do
     {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250"}
  end
end
