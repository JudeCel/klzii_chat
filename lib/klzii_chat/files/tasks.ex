# No longer supported logic DainisL 04.01.1017
# defmodule KlziiChat.Files.Tasks do
#   alias KlziiChat.{Repo, Resource, ResourceView}
#   import Ecto.Query
#
#   def zip_extension, do: ".zip"
#
#   def base_zip_processing_dir do
#      System.tmp_dir <> "/klzii_chat_zips/" <>  to_string(Mix.env) <>  "/"
#   end
#
#   @spec run(%Resource{}, List.t) :: {:ok, %Resource{} | {:error, String.t}}
#   def run(zip_record, ids) do
#     current_dir = File.cwd!
#     id = to_string(zip_record.id)
#
#     with {:ok, list} <- build_resource_list(ids),
#       {:ok } <- download(id, list),
#       {:ok, path} <- zip(id, zip_record.name),
#       :ok <- File.cd(current_dir),
#       {:ok, resource } <- update_success_zip(zip_record.id, path),
#       do: {:ok, resource}
#     else
#       {:error, reason} ->
#         update_failed_zip(zip_record.id, reason)
#         {:error, reason}
#       {key, val} ->
#         {key, val}
#
#   end
#
#
#   @spec update_success_zip(List.t, String.t ) :: %Resource{}
#   def update_success_zip(id, file_path) do
#     Repo.get!(Resource, id)
#       |> Resource.changeset(%{"file" => file_path, "status" => "completed"})
#       |> Repo.update
#   end
#   @spec update_failed_zip(List.t, String.t) :: %Resource{}
#   def update_failed_zip(id, reason) do
#     resource = Repo.get!(Resource, id)
#     properties = resource.properties |> Map.put(:error, reason)
#
#     Resource.changeset(resource, %{"status" => "failed", "properties" => properties})
#     |> Repo.update
#   end
#
#   @spec build_resource_list(List.t) :: {:ok, List.t }
#   def build_resource_list(ids) do
#     result =
#       from( r in Resource,
#         where: r.id in ^ids,
#         where: r.type in ~w(image audio file video)
#       )|> Repo.all
#       |> Enum.map(fn resource ->
#         resp = ResourceView.render("resource.json", %{resource: resource})
#         name = resp.name <> "." <> (resp.extension || "")
#         {name, resp.url.full}
#       end)
#     {:ok, result}
#   end
#
#   @spec download(String.t, List.t) :: {:ok }
#   def download(_,[]) do
#     {:error, "Ids list can't be empty!"}
#   end
#   def download(resource_id, list) do
#     {:ok, current_dir} = to_string(resource_id) |> build_tmp_dir
#     if(Mix.env == :test) do
#       {:ok}
#     else
#       try do
#         Enum.map(list, fn {name, url} ->
#           resp = HTTPoison.get(url)
#           File.write(current_dir <> name, resp.body)
#         end)
#         {:ok}
#       rescue
#         error ->
#           {:error, error}
#       end
#     end
#   end
#
#   @spec zip(String.t, String.t) :: {:ok, String.t }
#   def zip(resource_id, zip_name) do
#     {:ok, current_dir} = init_dir(resource_id)
#     {:ok, file_name} = build_zip(zip_name, resource_id)
#     {:ok, current_dir <> file_name}
#   end
#
#   @spec build_zip(String.t, String.t) :: {:ok, String.t }
#   def build_zip(zip_name, _) do
#      {:ok, _} = :zip.create(zip_name <> zip_extension, files_in_dir(zip_name))
#   end
#
#   @spec init_dir(String.t) :: {:ok, String.t }
#   def init_dir(resource_id) do
#     {:ok, path} = build_tmp_dir(resource_id)
#     :ok = File.cd(path)
#     {:ok, path }
#   end
#
#   @spec files_in_dir(String.t) :: [String.t, ...]
#   def files_in_dir(zip_name) do
#     full_file_name = zip_name <>".zip"
#     File.ls!
#       |> Enum.filter(fn file -> !String.contains?(file, full_file_name)  end)
#       |> Enum.map(&String.to_char_list/1)
#   end
#
#   @spec build_tmp_dir(String.t) :: {:ok, String.t}
#   def build_tmp_dir(resource_id) do
#     path = base_zip_processing_dir <> resource_id <> "/"
#     :ok = File.mkdir_p(path)
#     {:ok, path}
#   end
# end
