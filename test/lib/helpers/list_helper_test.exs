defmodule KlziiChat.Helpers.ListHelperTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Helpers.ListHelper

  test "str_to_num" do
    assert([] === ListHelper.str_to_num([]))
    assert([1] === ListHelper.str_to_num([1]))
    assert([1] === ListHelper.str_to_num(["1"]))
    assert([1, 2, 3, 4] === ListHelper.str_to_num([1, "2", 3, "4"]))
  end

  test "find diff " do
    assert(ListHelper.find_diff([7, 2], [2, 4]) == [4, 7])
    assert(ListHelper.find_diff([], [2, 4]) == [2, 4])
    assert(ListHelper.find_diff([1, 3], []) == [1, 3])
    assert(ListHelper.find_diff([1, 3], [3]) == [1])
    assert(ListHelper.find_diff([1, 3], [2]) == [2, 1, 3])
  end
end
