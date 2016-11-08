defmodule KlziiChat.Helpers.MapHelper do
  @spec key_to_string(Map.t| Struct.t) :: Map
  def key_to_string(%{__struct__: _} = data) do
    for {key, val} <- Map.from_struct(data), into: %{}, do: {to_string(key), val}
  end
  def key_to_string(data) do
    for {key, val} <- data, into: %{}, do: {to_string(key), val}
  end
end
