defmodule KlziiChat.Services.FileServiceTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.FileService

  @tmp_path Path.expand("/tmp/klzii_chat/reporting")
  @report_name "file_service_test_report"

  test "get full path from dir, file name and extension" do
    assert(FileService.compose_path(@tmp_path, @report_name, "qwerty") ==
      Path.join(@tmp_path, @report_name) <> ".qwerty")
  end

  test "write stream data to file" do
    path_to_file = FileService.compose_path(@tmp_path, @report_name, "stream")
    data_string =
      """
      12356 abcDEF  !@~^|
      ЫЪЭюя №Ё'
      """
    data_stream =
      String.codepoints(data_string)
      |> Stream.map(&(&1))

    :ok = FileService.write_data(path_to_file, data_stream)
    {:ok, data_from_file} = File.read(path_to_file)

    assert(data_from_file == data_string)
  end

  test "write string data to file" do
    path_to_file = FileService.compose_path(@tmp_path, @report_name, "string")
    data_string =
      """
      12356 abcDEF  !@~^|
      ЫЪЭюя №Ё'
      """

    :ok = FileService.write_data(path_to_file, data_string)
    {:ok, data_from_file} = File.read(path_to_file)

    assert(data_from_file == data_string)
  end
end
