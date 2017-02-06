defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.Formats.Xlsx do
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.DataContainer
  alias Elixlsx.{Sheet, Workbook}
  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    sheet1 = Sheet.with_name(get_in(data, ["header_title"]))
    workbook = %Workbook{sheets: [sheet1]}
    # IO.inspect data
    {:ok, %{data: workbook, header: []}}
  end

  # @spec map_data(Map.t,  Map.t, List.t, Process.t, Process.t) :: List.t
  # def map_data(mini_survey, session, fields, acc, container) do
  #   Enum.each(mini_survey.mini_survey_answers, fn(answer) ->
  #     map_fields(fields, mini_survey, answer, session, container)
  #     |> update_accumulator(acc)
  #   end)
  # end
  #
  # def update_accumulator(new_data, acc) do
  #   :ok = Agent.update(acc, fn(data) -> data ++  [Enum.into(new_data,%{})] end)
  # end
  #
  # def map_fields(fields, mini_survey, answer, session, container) do
  #   Enum.map(fields, fn(field) ->
  #     {field,  DataContainer.get_value(field, mini_survey, answer, session, container)}
  #   end)
  # end
end
