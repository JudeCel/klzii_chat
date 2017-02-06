defmodule KlziiChat.Services.FileService do

  @tmp_path "/tmp/klzii_chat/reporting"
  @footer_path File.cwd! <> "/web/templates/reporting/preview/footer.html"


  @spec get_tmp_path(String.t) :: String.t
  def get_tmp_path(dir_name) do
    path = "#{@tmp_path}/#{to_string(dir_name)}"
    :ok = File.mkdir_p!(path)
    path
  end

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

  @spec html_elements_to_pdf(Keyword.t, boolean) :: {:ok | :error, String.t}
  def html_elements_to_pdf(paths, binary) do
    Map.to_list(paths)
    |> Enum.all?(fn({_, path}) ->
      File.exists?(path)
    end)
    |>  case do
          true -> wkhtmltopdf(paths, binary)
          false -> {:error, "HTML file not found"}
        end

  end

  @spec wkhtmltopdf(Map.t, binary) :: {:ok | :error, String.t}
  def wkhtmltopdf(%{body: body, header: header, destination: destination}, binary) do
    case conwert_with_xvfb(body, header, destination) do
      {:ok, path} ->
        if binary do
          binary_data = File.read!(path)
          File.rm(path)
          {:ok, binary_data}
        else
          {:ok, path}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def conwert_with_xvfb(tmp_body, tmp_header, destination_path) do
    options = [
      "--auto-servernum",
      "wkhtmltopdf", "--page-size", "A4", "--dpi", "100",
      "--header-spacing", "5",
      "--footer-html", @footer_path, "--header-html", tmp_header, "file://" <> tmp_body, destination_path
    ]
    case System.cmd("xvfb-run", options , stderr_to_stdout: true) do
      {_, 0} ->
        :ok = File.rm(tmp_header)
        :ok = File.rm(tmp_body)
        {:ok, destination_path}
      {stdout, _} ->
        {:error, stdout}
    end
  end

  def create_and_write_html_tmp_file(tmp_dir_path, name, data) do
    path = compose_path(tmp_dir_path, to_string(name), "html")
    :ok = write_data(path, data)
    {name, path}
  end

  def create_destination_file(tmp_dir_path, name, format) do
    path = compose_path(tmp_dir_path, to_string(name), format)
    :ok = File.touch(path)
    {:destination, path}
  end

  def write_data_xlsx(path, %{data: data}, binary) do
    Elixlsx.write_to(data, path)
    if binary do
      binary_data = File.read!(path)
      File.rm(path)
      {:ok, binary_data}
    else
      {:ok, path}
    end
  end

  def write_data_csv(path, %{data: data, header: header }) do
    data_stream = Agent.get(data, &(&1))
    |> CSV.encode(headers: header)
    :ok = write_data(path, data_stream )
    {:ok, path}
  end
  def write_data_csv(path, data) do
    {:error, %{wrong_data: "path:#{path}, data_map: #{is_map(data)}, data_streem: #{is_function(data)}" }}
  end

  def write_data_txt(path, %{data: data, header: header }) do
    data_stream = Agent.get(data, &(&1))
    :ok = write_data(path, Enum.concat([header], data_stream) )
    {:ok, path}
  end
  def write_data_txt(path, data) do
    {:error, %{wrong_data: "path:#{path}, data_map: #{is_map(data)}, data_streem: #{is_function(data)}" }}
  end

  @spec write_report(Map.t, Stream.t | Map.t, Keyword.t) :: {:ok, String.t}
  def write_report(%{id: id, format: format, name: name}, data, [binary: binary]) when is_map(data) and format in ["pdf"] do
    tmp_dir_path = get_tmp_path(id)
    [
      fn -> create_and_write_html_tmp_file(tmp_dir_path, :header, data.header) end,
      fn -> create_and_write_html_tmp_file(tmp_dir_path, :body, data.body) end,
      fn -> create_destination_file(tmp_dir_path, name, format) end
    ]
    |> Enum.map(&Task.async(&1))
    |> Task.yield_many
    |> Enum.map(fn({_, {:ok, path}}) -> path end)
    |> Enum.into(%{})
    |> html_elements_to_pdf(binary)
  end
  def write_report(%{id: id, format: format, name: name}, data, [binary: binary]) when format in ["xlsx"]  do
    tmp_dir_path = get_tmp_path(id)
    {_,file_path} = create_destination_file(tmp_dir_path, name, format)
    write_data_xlsx(file_path, data, binary)
  end
  def write_report(%{id: id, format: format, name: name}, data, [binary: _]) when format in ["csv"]  do
    tmp_dir_path = get_tmp_path(id)
    {_,file_path} = create_destination_file(tmp_dir_path, name, format)
    write_data_csv(file_path, data)
  end
  def write_report(%{id: id, format: format, name: name}, data, [binary: _]) when format in ["txt"]  do
    tmp_dir_path = get_tmp_path(id)
    {_,file_path} = create_destination_file(tmp_dir_path, name, format)
    write_data_txt(file_path, data)
  end
  def write_report(%{id: id, format: format, name: name}, data, [binary: _])  do
    {:error, %{wrong_data: "id:#{id}, format:#{format}, name:#{name}, map: #{is_map(data)}, streem: #{is_function(data)}" }}
  end
end
