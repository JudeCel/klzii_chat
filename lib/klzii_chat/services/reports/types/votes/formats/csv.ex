defmodule KlziiChat.Services.Reports.Types.Votes.Formats.Csv do
  alias KlziiChat.Services.Reports.Types.Votes.DataContainer

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    session = get_in(data, ["session"])
    fields = get_in(data, ["fields"])
    [session_topic |_ ] = get_in(data, ["session_topics"])
    {:ok, acc} = Agent.start_link(fn -> [] end)
    {:ok, container} = DataContainer.start_link(session.participant_list)

    Enum.each(session_topic.mini_surveys, &map_data(&1, session, fields, acc, container))

    {:ok, %{data: acc, header: fields}}
  end

  @spec map_data(Map.t,  Map.t, List.t, Process.t, Process.t) :: List.t
  def map_data(mini_survey, session, fields, acc, container) do
    Enum.each(mini_survey.mini_survey_answers, fn(answer) ->
      map_fields(fields, mini_survey, answer, session, container)
      |> update_accumulator(acc)
    end)
  end

  def update_accumulator(new_data, acc) do
    :ok = Agent.update(acc, fn(data) -> data ++  [Enum.into(new_data,%{})] end)
  end

  def map_fields(fields, mini_survey, answer, session, container) do
    Enum.map(fields, fn(field) ->
      {field,  DataContainer.get_value(field, mini_survey, answer, session, container)}
    end)
  end
end
