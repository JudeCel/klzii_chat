defmodule KlziiChat.Files.Tasks do
  alias KlziiChat.{Repo, Resource}

  def zip_extension, do: ".zip"

  def base_zip_processing_dir do
     System.tmp_dir <> "/klzii_chat_zips/" <>  to_string(Mix.env) <>  "/"
  end

  @spec run(%Resource{}, List.t) :: {:ok}

  def run(zip_record, ids) do
    current_dir = File.cwd!
    id = to_string(zip_record.id)
    {:ok, list} = buidld_resource_list(ids)

    {:ok} = download(id, list)
    {:ok, path} = zip(id, zip_record.name)
    File.cd(current_dir)
    {:ok}
  end

  def buidld_resource_list(ids) do
    {:ok, []}
  end

  @spec download(String.t, List.t) :: {:ok }
  def download(_,[]) do
    raise("Ids list can't be empty!")
  end
  def download(resurce_id, list) do
    {:ok, current_dir} = to_string(resurce_id) |> build_tmp_dir
    case Mix.env do
      :test ->
          {:ok}
      _ ->
        Enum.map(list, fn {name, url} ->
          resp = HTTPotion.get(url)
          File.write(current_dir <> name, resp.body)
        end)
    end
    {:ok}
  end

  @spec zip(String.t, String.t) :: {:ok, String.t }
  def zip(resurce_id, zip_name) do
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
    {:ok, path} = build_tmp_dir(resurce_id)
    :ok = File.cd(path)
    {:ok, path }
  end

  @spec files_in_dir() :: [String.t, ...]
  def files_in_dir do
    File.ls!
      |> Enum.map(&String.to_char_list/1)
  end

  @spec build_tmp_dir(String.t) :: {:ok, String.t}
  def build_tmp_dir(resurce_id) do
    path = base_zip_processing_dir <> resurce_id <> "/"
    :ok = File.mkdir_p(path)
    {:ok, path}
  end
end
