defmodule KlziiChat.Services.Reports.Types.Statistic.Formats.Csv do
  alias KlziiChat.Services.Reports.Types.Statistic.DataContainer

  @spec processe_data(Map.t) :: {String.t}
  def processe_data(data) do
    render_string(data)
  end

  @spec render_string( Map.t) :: {:ok, String.t} | {:error, Map.t}
  def render_string(data) do
    session = get_in(data, ["session"])
    fields = get_in(data, ["fields"])
    statistic = get_in(data, ["statistic"])
    {:ok, acc} = Agent.start_link(fn -> [] end)
    {:ok, container} = DataContainer.start_link(session.participant_list)

    topic_list =
      session.session_topics
      |> Enum.map(&({&1.id, &1.name}))

    topic_map = Enum.into(topic_list, %{})
    topic_names = Enum.map(topic_list, fn({_, name}) -> name end)

    Map.keys(statistic)
    |> Enum.each(fn(id) ->
      map_data(Map.get(statistic, id), topic_map, topic_names, session, fields, container, acc)
    end)

    {:ok, %{header: fields ++ topic_names , data: acc}}
  end

  @spec map_data(List.t, List.t, List.t, Map.t, List.t, Process.t, Process.t) :: List.t
  def map_data(list, topic_map, topic_names, session, fields, container, acc) when is_list(list) do

    topics =
      Enum.map(topic_names, &({&1, 0}))
      |> Enum.into(%{})

    topics_data =
      Enum.reduce(list, topics, fn({_, message_count, _,sessionTopicId}, acc) ->
        name = Map.get(topic_map, sessionTopicId)
        if name do
          Map.put(acc, name, message_count)
        else
          acc
        end
      end)

    map_fields(fields, List.first(list), session, container)
      |> Enum.into(%{})
      |> Map.merge(topics_data)
      |> update_accumulator(acc)
  end

  def update_accumulator(new_data, acc) do
    :ok = Agent.update(acc, fn(data) -> data ++  [new_data] end)
  end

  def map_fields(fields, data, session, container) do
    Enum.map(fields, fn(field) ->
      {field, DataContainer.get_value(field, data, session, container)}
    end)
  end
end
