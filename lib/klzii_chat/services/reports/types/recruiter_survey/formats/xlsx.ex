defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Formats.Xlsx do
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
            |> Sheet.set_cell("A4", "Total Surveys Completed")
            |> Sheet.set_cell("C3", "Count")
            |> Sheet.set_cell("C4", get_in(stats, [:total_count]))
            |> Sheet.set_cell("D3", "%")
            |> Sheet.set_cell("D4", get_in(stats, [:total_count_percents]) || 100)
    sheet_acc = %{main_sheet: header_sheet, line_number: 5, sheets: [] }

    %{main_sheet: main_sheet, sheets: sheets, line_number: _} =
      Enum.reduce(get_in(stats, [:questions]), sheet_acc, fn(question, acc) ->
        map_question(acc, question)
     end)

    workbook = %Workbook{sheets: [main_sheet] ++ sheets }
    {:ok, %{data: workbook, header: []}}
  end

  def map_question(acc, %{type: "textarea", name: name} = question) do
    tmp_sheet =
      Sheet.with_name(name)
      |> Sheet.set_cell("A1", name)

      valuses =
        question.answers
        |> List.first
        |> Map.get(:values)

      %{sheet: sheet} =
        Enum.reduce(valuses, %{sheet: tmp_sheet, line_number: 2}, fn(answer, sheet_acc) ->
          t_sheet = Sheet.set_cell(sheet_acc.sheet, "A#{sheet_acc.line_number}", answer)
          Map.put(sheet_acc, :sheet,  t_sheet)
          |> Map.put(:line_number, sheet_acc.line_number + 1)
        end)
    Map.put(acc, :sheets, acc.sheets ++ [sheet])
  end
  def map_question(acc, question) do
    tmp_sheet =
      Sheet.set_cell(acc.main_sheet, "A#{acc.line_number}", get_in(question, [:name]))
    Map.put(acc, :main_sheet, tmp_sheet)
      |> map_data_answer(question.answers)
  end

  @spec map_data_answer(Map.t,  List.t) :: Map.t
  def map_data_answer(acc, [head| tail]) do
    map_data_answer(acc, head)
    |> map_data_answer(tail)
  end
  def map_data_answer(acc, answer) do
    tmp_sheet =
      Sheet.set_cell(acc.main_sheet, "B#{acc.line_number}", get_in(answer, [:name]))
      |> Sheet.set_cell("C#{acc.line_number}", get_in(answer, [:count]))
      |> Sheet.set_cell("D#{acc.line_number}", get_in(answer, [:percents]))

    Map.put(acc, :main_sheet, tmp_sheet)
    |> Map.put(:line_number, acc.line_number + 1)
  end
end
