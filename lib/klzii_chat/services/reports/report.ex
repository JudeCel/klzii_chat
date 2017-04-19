defmodule KlziiChat.Services.Reports.Report do
  alias KlziiChat.{Repo, SessionTopicsReport, Resource}
  alias KlziiChat.Services.Reports.Types.{Messages, Votes, Whiteboards, Statistic, PrizeDraw}
  alias KlziiChat.Services.FileService

  @spec run(Integer.t) :: {:ok, Map.t} | {:error, String.t}
  def run(report_id) do
    with  {:ok, report} <- get_report(report_id),
        {:ok, type_module} <- select_type(report.type),
        {:ok, report_data} <- process_data(type_module, report),
        {:ok, report_data} <- process_data(type_module, report, report_data),
    do: {:ok, report_data}
  end

  @spec get_report(Integer.t) :: {:ok, Map.t} | {:error, String.t}
  defp get_report(report_id) do
    Repo.get(SessionTopicsReport, report_id)
    |>  case  do
          nil ->
            {:error, %{not_found: "Report with id: #{report_id} not found"}}
          report ->
            {:ok, report}
        end
  end

  @spec process_data(String.t, %SessionTopicsReport{}) :: {:ok, Map.t} | {:error, String.t}
  def process_data(type_module, report) do
    case type_module.get_data(report) do
      {:ok, data} ->
        {:ok, data}
      {:error, reason} ->
        {:error, reason }
    end
  end
  def process_data(type_module, report, data) do
    with {:ok, format_modeule } <- type_module.format_modeule(report.format),
         {:ok, data} <- format_modeule.processe_data(data),
         {:ok, file_path} <- FileService.write_report(report, data, [binary: false]),
         {:ok, resource} <- create_resource(report, file_path),
         {:ok, update_report} <- add_resource(report, resource),
    do: {:ok, update_report}
  end

  @spec add_resource(%SessionTopicsReport{}, String.t) :: {:ok | :error, String.t | Map.t}
  def add_resource(report, resource) do
    SessionTopicsReport.changeset(report, %{resourceId: resource.id, status: "completed"})
    |> Repo.update
  end

  @spec add_resource(%SessionTopicsReport{}, String.t) :: {:ok | :error, Map.t}
  def create_resource(report, report_file_path) do
    preload_report = Repo.preload(report, [:session])
    upload_params = %{
      "type" => "file",
      "accountId" => preload_report.session.accountId,
      "scope" => to_string(report.format),
      "name" => report.name
    }
    Resource.report_changeset(%Resource{}, upload_params)
    |> Repo.insert
    |>  case  do
          {:ok, resource} ->
            Resource.report_changeset(resource, %{"file" => report_file_path})
            |> Repo.update
            |> case do
                {:ok, resource} ->
                  {:ok, resource}
                {:error, reason_update} ->
                  {:error, KlziiChat.ChangesetView.render("error.json", %{changeset: reason_update})}
               end
          {:error, reason} ->
            {:error, KlziiChat.ChangesetView.render("error.json", %{changeset: reason})}
        end
  end

  @spec select_type(String.t) :: {:ok , Module.t | :error, String.t}
  def select_type("messages"), do: {:ok, Messages.Base}
  def select_type("statistic"), do: {:ok, Statistic.Base}
  def select_type("messages_stars_only"), do: {:ok, Messages.Base}
  def select_type("prize_draw"), do: {:ok, PrizeDraw.Base}
  def select_type("votes"), do: {:ok, Votes.Base}
  def select_type("whiteboards"), do: {:ok, Whiteboards.Base}
  def select_type(type), do: {:error, "module for type #{type} not found"}
end
