defmodule KlziiChat.Files.TasksTest do
  @image_path "test/fixtures/images/hamster.jpg"
  use ExUnit.Case, async: true
  alias KlziiChat.Files.Tasks, as: FileZipTask

  test "create zip" do
    current_dir = File.cwd!
    zip_record_id = "1"
    zip_name = "new_zip"
    tmp_path = FileZipTask.base_zip_processing_dir <> zip_record_id <> "/"

    :ok = File.mkdir_p(tmp_path)
    :ok = File.cp(@image_path, tmp_path <> "hamster.jpg")
    {:ok, _} = FileZipTask.create_zip(zip_record_id, zip_name)
    {:ok, _} = File.rm_rf(FileZipTask.base_zip_processing_dir <> zip_record_id)
    File.cd(current_dir)
  end
end
