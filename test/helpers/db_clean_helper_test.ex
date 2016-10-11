defmodule KlziiChat.DbCleanHelperTest do
  use ExUnit.Case, async: true
  KlziiChat.DbCleanHelper

  test "can execute databas " do
    {:ok, _} = KlziiChat.DbCleanHelper.clean_up
  end
end
