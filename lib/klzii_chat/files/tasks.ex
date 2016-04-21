defmodule KlziiChat.Files.Tasks do
  alias KlziiChat.{Repo, Resource}
  def base_zip_processing_dir, do: "/tmp/klzii_chat_zips/"
  def zip_extension, do: ".zip"

  @spec run(%Resource{}, List.t) :: {:ok}
  def run(zip_record, ids) do
    current_dir = File.cwd!
    id = to_string(zip_record.id)
    {:ok, current_dir} = init_dir(id)
    {:ok, path} = create_zip(id, zip_record.name)
    File.cd(current_dir)
    {:ok}
  end

  @spec download(List.t) :: {:ok }
  def download(list) do
    Enum.map(list, fn {name, url} ->
      resp = HTTPotion.get(url)
      File.write(name, resp.body)
    end)
    {:ok}
  end

  @spec create_zip(String.t, String.t) :: {:ok, String.t }
  def create_zip(resurce_id, zip_name) do
    {:ok, current_dir} = init_dir(resurce_id)
    {:ok, file_name} = build_zip(zip_name, resurce_id)
    {:ok, current_dir <> file_name}
  end

  @spec build_zip(String.t, String.t) :: {:ok, String.t }
  def build_zip(zip_name, resurce_id) do
     {:ok, file_name} = :zip.create(zip_name <> zip_extension, files_in_dir)
  end

  @spec init_dir(String.t) :: {:ok, String.t }
  def init_dir(resurce_id) do
    path = base_zip_processing_dir <> resurce_id <> "/"
    :ok = File.mkdir_p(path)
    :ok = File.cd(path)
    {:ok, path}
  end

  @spec files_in_dir() :: [Tuple.t, ...]
  def files_in_dir do
    File.ls!
      |> Enum.map(&String.to_char_list/1)
  end
end
