defmodule KlziiChat.Services.FileServiceTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.FileService

  @report_name "file_service_test_report"
  @test_sub_dir  "test_sub_dir"

  describe "get_tmp_path" do
    test " create sub dir for report" do
      path = FileService.get_tmp_path(@test_sub_dir)
      assert(File.exists?(path))
    end
  end

  describe "compose_path" do
    test "create path with file" do
      file_name = "some_name"
      file_format = "html"
      path =
        FileService.get_tmp_path(@test_sub_dir)
        |> FileService.compose_path(file_name, file_format)
      assert(String.contains?(path, file_format))
      assert(String.contains?(path, file_name))
    end
  end
end
