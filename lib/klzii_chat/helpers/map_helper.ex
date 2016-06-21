defmodule KlziiChat.Helpers.MapHelper do
  @spec key_to_string(Map) :: Map
  def key_to_string(data) do
    Enum.reduce(data, %{}, fn { key, value }, acc ->
      Map.put(acc, to_string(key), value)
    end)
  end
end
