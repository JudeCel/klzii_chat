defmodule KlziiChat.Uploaders.Video do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original]
  @acl :public_read

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.mp4 .mpeg ) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  def __storage do
    case Mix.env do
      :prod ->
        Arc.Storage.S3
      _ ->
        Arc.Storage.Local
    end
  end

  def storage_dir(_, {_file, scope}) do
    case Mix.env do
      :prod ->
        "video/#{scope.accountId}/"
      _ ->
        "priv/static/uploads/video/#{scope.accountId}/"
    end
  end

  # Override the persisted filenames:
  def filename(version, {_file, scope}) do
    str = "#{version}_#{scope.name}"
    Regex.replace(~r/( |-)/, str, "")
  end
  def filename(version, _), do: version
end
