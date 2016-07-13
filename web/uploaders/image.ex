defmodule KlziiChat.Uploaders.Image do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb]
  @acl :public_read

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.gif .png .jpg .jpeg .bmp) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250>"}
  end
  def transform(:gallery_thumb, _) do
     {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250"}
  end

  def __storage do
    case Mix.env do
      :prod ->
        Arc.Storage.S3
      _ ->
        Arc.Storage.Local
    end
  end
  # Override the persisted filenames:
  def filename(version, {file, scope}) do
    str = "#{version}_#{scope.name}"
    Regex.replace(~r/( |-)/, str, "")
  end
  def filename(version, _), do: version

  def storage_dir(_, {file, scope}) do
    case Mix.env do
      :prod ->
        "uploads/images/#{scope.accountId}/"
      _ ->
        "priv/static/uploads/images/#{scope.accountId}"
    end
  end

end
