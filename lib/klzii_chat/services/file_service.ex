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

  @spec html_elements_to_pdf(Keyword.t) :: {:ok | :error, String.t}
  def html_elements_to_pdf(paths) do
    Map.to_list(paths)
    |> Enum.all?(fn({_, path}) ->
      File.exists?(path)
    end)
    |>  case do
          true -> wkhtmltopdf(paths)
          false -> {:error, "HTML file not found"}
        end

  end

  @spec wkhtmltopdf(Map.t) :: {:ok | :error, String.t}
  def wkhtmltopdf(%{body: body, header: header, destination: destination}) do
    case conwert_with_xvfb(body, header, destination) do
      {:ok, path} ->
        {:ok, path}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def conwert_with_xvfb(tmp_body, tmp_header, destination_path) do
    options = [
      "--auto-servernum",
      "wkhtmltopdf",
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
    path = path = compose_path(tmp_dir_path, to_string(name), format)
    :ok = File.touch(path)
    {:destination, path}
  end

  @spec write_report(Map.t, Stream.t | Map.t) :: {:ok, String.t}
  def write_report(%{id: id, format: format, name: name}, data) when is_map(data) and format in ["pdf"] do
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
    |> html_elements_to_pdf
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

  def write_report(%{id: id, format: format, name: name}, data) when format in ["csv"]  do
    tmp_dir_path = get_tmp_path(id)
    {_,file_path} = create_destination_file(tmp_dir_path, name, format)
    write_data_csv(file_path, data)
  end
  def write_report(%{id: id, format: format, name: name}, data) when format in ["txt"]  do
    tmp_dir_path = get_tmp_path(id)
    {_,file_path} = create_destination_file(tmp_dir_path, name, format)
    write_data_txt(file_path, data)
  end
  def write_report(%{id: id, format: format, name: name}, data)  do
    {:error, %{wrong_data: "id:#{id}, format:#{format}, name:#{name}, map: #{is_map(data)}, streem: #{is_function(data)}" }}
  end
end
