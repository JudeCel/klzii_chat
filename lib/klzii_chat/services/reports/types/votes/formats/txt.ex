defmodule KlziiChat.Services.Reports.Types.Votes.Formats.Txt do
  alias KlziiChat.Services.Reports.Types.Votes.DataContainer

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    session = get_in(data, ["session"])
    default_fields = get_in(data, ["default_fields"])
    [session_topic |_ ] = get_in(data, ["session_topics"])

    header = "#{session.name} / #{session_topic.name}\r\n\r\n"

    stream =
      session_topic.mini_surveys
      |> Enum.map(&get_data(&1, session, default_fields))

    {:ok, Enum.concat([header], stream)}
  end

  @spec get_data(Map.t,  Map.t, List.T) :: List.t
  def get_data(mini_survey, session, default_fields) do
    {:ok, container} = DataContainer.start_link(session.participant_list)

    row = Enum.map(default_fields, fn(field) ->
      DataContainer.get_value(field, mini_survey, session, container)
    end) |> Enum.join(", ")
    [row <> "\r\n\r\n"]
  end
end
