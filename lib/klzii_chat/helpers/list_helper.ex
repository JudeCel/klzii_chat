defmodule KlziiChat.Helpers.ListHelper do
  alias KlziiChat.Helpers.IntegerHelper
  
  @spec str_to_num(List) :: List
  def str_to_num(list) do
    Enum.map(list, &IntegerHelper.get_num/1)
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

  @spec find_diff_of_left(List.t, List.t) :: List.t
  def find_diff_of_left(first, second) do
    List.foldl(first, second, fn (id, acc) ->
      List.delete(acc, id)
    end)
  end
end
