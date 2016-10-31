defmodule KlziiChat.Services.Reports.Report do
  alias KlziiChat.{Repo, SessionTopicsReport, Resource}
  alias KlziiChat.Services.Reports.Types.{Messages, Votes, Whiteboards}
  alias KlziiChat.Services.FileService

  def run(report_id) do
    with  report <- get_report(report_id),
        {:ok, type_module} <- select_type(report.type),
        {:ok, report_data} <- process_data(type_module, report),
        {:ok, report_data} <- process_data(type_module, report, report_data),
    do: {:ok, report_data}
  end

  defp get_report(report_id) do
    Repo.get(SessionTopicsReport, report_id)
  end

  def process_data(type_module, report) do
    case type_module.get_data(report) do
      {:ok, data} ->
        {:ok, data}
      {:error, reason} ->
        {:error, reason }
    end
  end

  def process_data(type_module, %{format: format, name: name} = report, data) do
    with {:ok, format_modeule } <- type_module.format_modeule(format),
         {:ok, data} <- format_modeule.processe_data(data),
         {:ok, file_path} <- FileService.write_report(name, format, data),
         {:ok, resource} <- create_resource(report, file_path),
         {:ok, update_report} <- add_resource(report, resource),
    do: {:ok, update_report}
  end

  @spec add_resource(%SessionTopicsReport{}, String.t) :: {:ok | :error, String.t}
  def add_resource(report, resource) do
    SessionTopicsReport.changeset(report, %{resourceId: resource.id, status: "completed"})
    |> Repo.update
  end

  def create_resource(report, report_file_path) do
    preload_report = Repo.preload(report, [:session])
    upload_params = %{
      "type" => "file",
      "accountId" => preload_report.session.accountId,
      "scope" => to_string(report.format),
      "file" => report_file_path,
      "name" => report.name
    }
    Resource.report_changeset(%Resource{}, upload_params)
    |> Repo.insert
  end

  def select_type("messages"), do: {:ok, Messages.Base}
  def select_type("messages_stars_only"), do: {:ok, Messages.StarOnly}
  def select_type("votes"), do: {:ok, Votes.Base}
  def select_type("whiteboards"), do: {:ok, Whiteboards.Base}
  def select_type(type), do: {:error, "module for type #{type} not found"}
end
