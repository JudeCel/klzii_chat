defmodule KlziiChat.Services.Permissions.ConsolePermissionsTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.Console

  describe("facilitator") do
    test "can set resource" do
      member = %{id: 1, role: "facilitator"}
      assert({:ok} = Console.can_set_resource(member))
    end

    test "can remove resource" do
      member = %{id: 1, role: "facilitator"}
      assert({:ok} = Console.can_remove_resource(member))
    end
  end

  describe("participent") do
    test "can set resource" do
      member = %{id: 1, role: "participant"}
      assert({:error, _} = Console.can_set_resource(member))
    end

    test "can remove resource" do
      member = %{id: 1, role: "participant"}
      assert({:error, _} = Console.can_remove_resource(member))
    end
  end

  describe("observer") do
    test "can set resource" do
      member = %{id: 1, role: "observer"}
      assert({:error, _} = Console.can_set_resource(member))
    end

    test "can remove resource" do
      member = %{id: 1, role: "observer"}
      assert({:error, _} = Console.can_remove_resource(member))
    end
  end
end
