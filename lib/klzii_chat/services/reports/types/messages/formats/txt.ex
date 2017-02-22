defmodule KlziiChat.Services.Reports.Types.Messages.Formats.Txt do
  alias KlziiChat.Services.Reports.Types.Messages.DataContainer

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    session = get_in(data, ["session"])
    fields = ["Comment"]
    [session_topic |_ ] = get_in(data, ["session_topics"])
    {:ok, acc} = Agent.start_link(fn -> [] end)
    {:ok, container} = DataContainer.start_link(session.participant_list)

    map_data(session_topic.messages, session, fields, container, acc)
    {:ok, %{header: [session_topic.name], data: acc}}
  end

  @spec map_data(List.t,  Map.t, List.t, Process.t, Process.t) :: List.t
  def map_data([], _, _, _, acc), do: acc
  def map_data([message | tail], session, fields, container, acc) do
    map_fields(fields, message, session, container) |> update_accumulator(acc)
    map_data(message.replies, session, fields, container, acc)
    map_data(tail, session, fields, container, acc)
  end
  def map_data(message, session, fields, container, acc) do
    map_fields(fields, message, session, container) |> update_accumulator(acc)
  end

  def update_accumulator(new_data, acc) do
    :ok = Agent.update(acc, fn(data) -> data ++  new_data end)
  end

  def map_fields(fields, message, session, container) do
    row = Enum.map(fields, fn(field) ->
      DataContainer.get_value(field, message, session, container)
    end) |> Enum.join(", ")
    ["\r\n" <> row]
  end
end
