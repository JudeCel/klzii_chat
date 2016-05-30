defmodule KlziiChat.Services.FileService do

  @spec compose_path(String.t, String.t, String.t) :: String.t
  def compose_path(path_to_dir, file_name, file_extension) do
    Path.join(path_to_dir, file_name) <> "." <> file_extension
  end


  @spec write_data(String.t, String.t) :: :ok | {:error, atom}
  def write_data(file_path, data_string) when is_bitstring(data_string) do
    {:ok, file} = File.open(file_path, [:write])
    :ok = IO.binwrite(file, data_string)
    File.close(file)
  end

  @spec write_data(String.t, Enum.t) :: :ok | {:error, atom}
  def write_data(file_path, data_stream) do
    {:ok, file} = File.open(file_path, [:write])
    Enum.each(data_stream, &(:ok = IO.binwrite(file, &1)))
    File.close(file)
  end
end
