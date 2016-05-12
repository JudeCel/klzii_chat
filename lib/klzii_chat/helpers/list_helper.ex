defmodule KlziiChat.Helpers.ListHelper do

  @spec str_to_num(List) :: List
  def str_to_num(list) do
    Enum.map(list, &get_num/1)
  end

  defp get_num(l_el) when is_integer(l_el), do: l_el

  defp get_num(l_el) when is_bitstring(l_el) do
    {num, ""} = Integer.parse(l_el)
    num
  end


  @spec find_diff(List.t, List.t) :: List.t
  def find_diff(first, second) do
    List.foldl(first, second, fn (id, acc) ->
      result = List.delete(acc, id)
      if result == acc do
        result ++ [id]
      else
        result
      end
    end)
  end
end
