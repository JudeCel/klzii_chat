defmodule KlziiChat.Services.FileService do

  @tmp_path "/tmp/klzii_chat/reporting"
  @footer_path File.cwd! <> "/web/templates/reporting/preview/footer.html"


  @spec get_tmp_path() :: String.t
  def get_tmp_path() do
    if not File.exists?(@tmp_path), do: :ok = File.mkdir_p(@tmp_path)
    @tmp_path
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

  @spec html_to_pdf(String.t) :: {:ok | :error, String.t}
  def html_to_pdf(path_to_html) do
    case File.exists?(path_to_html) and Path.extname(path_to_html) == ".html" do
      true -> wkhtmltopdf(path_to_html)
      false -> {:error, "HTML file not found"}
    end
  end

  @spec wkhtmltopdf(String.t) :: {:ok | :error, String.t}
  def wkhtmltopdf(path_to_html) do
    path_to_pdf = Path.rootname(path_to_html) <> ".pdf"

    case conwert_with_xvfb(path_to_html, path_to_pdf) do
      {:ok, path} ->
        {:ok, path}
      {:error, reason} ->
        IO.inspect(reason)
        {:error, reason}
    end
  end

  def conwert_with_xvfb(path_to_html, path_to_pdf) do
    options = [
      "--auto-servernum", "--server-args", "-screen 0, 1600x1200x24",
      "wkhtmltopdf", "--use-xserver", "--disable-smart-shrinking",
      "--footer-html", @footer_path, "file://" <> path_to_html, path_to_pdf
    ]
    case System.cmd("xvfb-run", options , stderr_to_stdout: true) do
      {_, 0} ->
        :ok = File.rm(path_to_html)
        {:ok, path_to_pdf}
      {stdout, _} ->
        {:error, stdout}
    end
  end

  def function_name do

  end


  @spec write_report(String.t, :pdf, String.t | Stream.t) :: {:ok, String.t}
  def write_report(report_name, :pdf, report_data) do
    tmp_html_file_path =
        get_tmp_path()
        |> compose_path(report_name, "html")
    :ok = write_data(tmp_html_file_path, report_data)
    html_to_pdf(tmp_html_file_path)
  end

  @spec write_report(String.t, atom, String.t | Stream.t) :: {:ok, String.t}
  def write_report(report_name, report_format, report_data) when report_format in [:txt, :csv]  do
    report_file_path =
      get_tmp_path()
      |> compose_path(report_name, to_string(report_format))
    :ok = write_data(report_file_path, report_data)
    {:ok, report_file_path}
  end
end
