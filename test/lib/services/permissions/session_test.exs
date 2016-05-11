defmodule KlziiChat.Services.Permissions.SessionTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.Session, as: SessionPermissions

  test "facilitator can toggle session resources" do
    facilitator = %{id: 1, role: "facilitator"}
    SessionPermissions.can_toggle_resources(facilitator)
    |> assert
  end

  test "participant can't toggle session resources" do
    participant = %{id: 2, role: "participant"}
    SessionPermissions.can_toggle_resources(participant)
    |> refute
  end
end
