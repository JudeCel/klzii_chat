defmodule KlziiChat.Helpers.StringHelperTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Helpers.StringHelper

  test "Double quote string" do
    assert(~s("test") == StringHelper.double_quote("test"))
    assert(~s("te""st") == StringHelper.double_quote("te\"st"))
  end
end
