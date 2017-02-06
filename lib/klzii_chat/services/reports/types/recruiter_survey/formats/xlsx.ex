defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Formats.Xlsx do
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.DataContainer
  alias Elixlsx.{Sheet, Workbook}
  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    stats =  get_in(data, ["survey_questions_stats"])

    header_sheet = Sheet.with_name(get_in(data, ["header_title"]))
            |> Sheet.set_cell("A1", "Recruiter Stats Report")
            |> Sheet.set_cell("A3", get_in(data, ["header_title"]))
            |> Sheet.set_cell("C3", "Count")
            |> Sheet.set_cell("D3", "%")
            |> Sheet.set_cell("A4", "Total Surveys Completed")
            |> Sheet.set_cell("E4", get_in(stats, [:total_count]))
    sheet_acc = %{sheet: header_sheet, line_number: 5}

    %{sheet: sheet} =
      Enum.reduce(get_in(stats, [:questions]), sheet_acc, fn(question, acc) ->
        tmp_sheet =
          Sheet.set_cell(acc.sheet, "A#{acc.line_number}", get_in(question, [:name]))
        Map.put(acc, :sheet, tmp_sheet)
          |> map_data_answer(question.answers)
     end)

    workbook = %Workbook{sheets: [sheet]}
    {:ok, %{data: workbook, header: []}}
  end

  @spec map_data_answer(Map.t,  List.t) :: Map.t
  def map_data_answer(acc, [head| tail]) do
    map_data_answer(acc, head)
    |> map_data_answer(tail)
  end

  def map_data_answer(acc, answer) do
    tmp_sheet =
      Sheet.set_cell(acc.sheet, "B#{acc.line_number}", get_in(answer, [:name]))
      |> Sheet.set_cell("C#{acc.line_number}", get_in(answer, [:count]))
      |> Sheet.set_cell("D#{acc.line_number}", get_in(answer, [:percents]))

    Map.put(acc, :sheet, tmp_sheet)
    |> Map.put(:line_number, acc.line_number + 1)
  end
end
