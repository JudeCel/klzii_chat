defmodule KlziiChat.Services.Reports.Report do
  alias KlziiChat.{Repo, SessionTopicsReport}
  alias KlziiChat.Services.Reports.Types.{Messages, Votes, Whiteboards}
  alias KlziiChat.Services.Reports.Formats.{Pdf, Csv, Txt}

  def run(report_id) do
    with  report <- get_report(report_id),
        {:ok, type_module} <- select_type(report.type),
        {:ok, report_data} <- process_data(type_module, report),
        {:ok, format_module} <- select_format(report.format),
        {:ok} <- process_data(format_module, report.type, report_data),
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

  def process_data(format_module, type, data) do
    {:ok}
    # case format_module.process_data(type, data) do
    #   {:ok, data} ->
    #     {:ok, data}
    #   {:error, reason} ->
    #     {:error, reason }
    # end
  end

  def select_type("messages"), do: {:ok, Messages.Base}
  def select_type("messages_stars_only"), do: {:ok, Messages.StarOnly}
  def select_type("votes"), do: {:ok, Votes.Base}
  def select_type("whiteboards"), do: {:ok, Whiteboards.Base}
  def select_type(type), do: {:error, "module for type #{type} not found"}

  def select_format("pdf"), do: {:ok, Pdf}
  def select_format("csv"), do: {:ok, Csv}
  def select_format("txt"), do: {:ok, Txt}
  def select_format(format), do: {:error, "module for format #{format} not found"}


end
