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

  @spec html_to_pdf(String.t) :: :ok | {:error, String.t}
  def html_to_pdf(path_to_html) do
    case File.exists?(path_to_html) and Path.extname(path_to_html) == ".html" do
      true -> wkhtmltopdf(path_to_html)
      false -> {:error, "HTML file not found"}
    end
  end

  @spec wkhtmltopdf(String.t) :: {:ok | :error, String.t}
  defp wkhtmltopdf(path_to_html) do
    path_to_pdf = Path.rootname(path_to_html) <> ".pdf"

    case System.cmd("wkhtmltopdf", ["file://" <> path_to_html, path_to_pdf], stderr_to_stdout: true) do
      {_, 0} ->
        :ok = File.rm(path_to_html)
        {:ok, path_to_pdf}
      {stdout, _} -> {:error, stdout}
    end
  end

end
