defmodule KlziiChat.Services.Reports.Types.Messages.Formats.Txt do
  alias KlziiChat.Services.Reports.Types.Messages.DataContainer

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
      session_topic.messages
      |> Enum.map(&get_data(&1, session, default_fields))

    {:ok, Enum.concat([header], stream)}
  end

  @spec get_data(Map.t,  Map.t, List.T) :: List.t
  def get_data(message, session, default_fields) do
    data_container = DataContainer.start_link(session.participant_list)

    row = Enum.map(default_fields, fn(field) ->
      DataContainer.get_value(field, message, session, data_container)
    end) |> Enum.join(", ")
    [row <> "\r\n\r\n"]
  end
end
