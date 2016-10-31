defmodule KlziiChat.Services.Reports.Report do
  alias KlziiChat.{Repo, SessionTopicsReport}
  alias KlziiChat.Services.Reports.Types.{Messages, Votes, Whiteboards}
  alias KlziiChat.Services.FileService

  def run(report_id) do
    with  report <- get_report(report_id),
        {:ok, type_module} <- select_type(report.type),
        {:ok, report_data} <- process_data(type_module, report),
        {:ok} <- process_data(type_module, report, report_data),
    do: {:ok, get_report(report.id)}
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

  def process_data(type_module, %{format: format, name: name}, data) do
    with {:ok, format_modeule } <- type_module.format_modeule(format),
         {:ok, data} <- format_modeule.processe_data(data),
         {:ok, data} <- FileService.write_report(name, format, data),
    do: {:ok, data}
  end

  def select_type("messages"), do: {:ok, Messages.Base}
  def select_type("messages_stars_only"), do: {:ok, Messages.StarOnly}
  def select_type("votes"), do: {:ok, Votes.Base}
  def select_type("whiteboards"), do: {:ok, Whiteboards.Base}
  def select_type(type), do: {:error, "module for type #{type} not found"}
end
