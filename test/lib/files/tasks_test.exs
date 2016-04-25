defmodule KlziiChat.Files.TasksTest do
  @image_path "test/fixtures/images/hamster.jpg"
  @zip_record_id "1"
  use ExUnit.Case, async: true
  alias KlziiChat.Files.Tasks, as: FileZipTask

  setup do
    current_dir = File.cwd!

    on_exit fn ->
     File.cd(current_dir)
     {:ok, _} = File.rm_rf(FileZipTask.base_zip_processing_dir <> @zip_record_id)
   end
  end

  test "create zip" do
    zip_name = "new_zip"
    tmp_path = FileZipTask.base_zip_processing_dir <> @zip_record_id <> "/"
    :ok = File.mkdir_p(tmp_path)
    :ok = File.cp(@image_path, tmp_path <> "hamster.jpg")

    {:ok, file_path} = FileZipTask.zip(@zip_record_id, zip_name)
    {:ok, tmp_dir_reg} = Regex.compile(System.tmp_dir)
    {:ok, zip_file_name} = Regex.compile(zip_name)

    assert(Regex.match?(tmp_dir_reg, file_path))
    assert(Regex.match?(zip_file_name, file_path))
  end

  test "download ids can't be empty" do
    {:error, message} = FileZipTask.download("name",[])
    assert(message == "Ids list can't be empty!")
  end

  test "when init_dir then change current dir location" do
    {:ok, dir} = FileZipTask.init_dir("1")
    {:ok, tmp_dir_reg} = Regex.compile(System.tmp_dir)
    assert(Regex.match?(tmp_dir_reg, System.cwd))
  end

  test "files_in_dir return list" do
    FileZipTask.files_in_dir("some_zip_name")
    |> is_list
    |> assert
  end

  test "create tmp dir" do
     {:ok, path } = FileZipTask.build_tmp_dir(@zip_record_id)
     {:ok, tmp_dir_reg} = Regex.compile(System.tmp_dir)
     assert(Regex.match?(tmp_dir_reg, path))
  end
end
