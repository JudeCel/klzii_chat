defmodule KlziiChat.Helpers.ListHelper do
  def normalize_ids(ids) do
    Enum.map(ids, &get_normalized/1)
  end

  defp get_normalized(id) when is_integer(id), do: id

  defp get_normalized(id) when is_bitstring(id) do
    {num_id, ""} = Integer.parse(id)
    num_id
  end
end
