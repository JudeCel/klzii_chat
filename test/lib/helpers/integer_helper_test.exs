defmodule KlziiChat.IntegerHelperTest do
  use KlziiChat.ModelCase, async: true
  alias KlziiChat.Helpers.{IntegerHelper}

  test "integer test" do
    assert(1 = IntegerHelper.get_num(1))
  end

  test "valid string test" do
    assert(1 = IntegerHelper.get_num("1"))
  end

end
