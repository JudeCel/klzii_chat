defmodule KlziiChat.Uploaders.Image do
  use Arc.Definition
  use KlziiChat.Uploaders.StoreDefinition
  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb, :gallery_thumb]
  def versions, do: @versions
  @acl :public_read

  def allowed_extensions() do
    ~w(.gif .png .jpg .jpeg .bmp)
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250>"}
  end
  def transform(:gallery_thumb, {file, _scope}) do
    case Path.extname(file.file_name) do
      ".gif" ->
        {:convert, "-coalesce -repage 0x0 -gravity center +repage"}
      _ ->
        {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250"}
    end

  end
end
