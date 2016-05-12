defmodule KlziiChat.Services.Permissions.ConsolePermissionsTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Console

  test "can set resource" do
    member = %{id: 1, role: "facilitator"}
    Console.can_set_resource(member) |> assert
  end

  test "can remove resource" do
    member = %{id: 1, role: "facilitator"}
    Console.can_remove_resource(member) |> assert
  end
end
