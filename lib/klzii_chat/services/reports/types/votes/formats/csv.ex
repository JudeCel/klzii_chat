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

    stream =
      session_topic.mini_surveys
      |> Stream.map(&get_data(&1, session, fields))
      |> CSV.encode(headers: fields)
    {:ok, stream}
  end

  @spec get_data(Map.t,  Map.t, List.T) :: List.t
  def get_data(mini_survey, session, fields) do
    {:ok, container} = DataContainer.start_link(session.participant_list)

    Enum.map(mini_survey.mini_survey_answers, fn(answer) ->
      Enum.map(fields, fn(field) ->
        {field, DataContainer.get_value(field, mini_survey, answer, session, container)}
      end)
    end)
    |> List.flatten
    |> Enum.into(%{})
  end
end
