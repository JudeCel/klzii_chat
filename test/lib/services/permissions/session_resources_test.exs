defmodule KlziiChat.Services.Permissions.SessionResourcesTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions

  test "facilitator can toggle session resources" do
    facilitator = %{id: 1, role: "facilitator"}
    SessionResourcesPermissions.can_toggle_resources(facilitator)
    |> assert
  end

  test "participant can't toggle session resources" do
    participant = %{id: 2, role: "participant"}
    SessionResourcesPermissions.can_toggle_resources(participant)
    |> refute
  end

  test "facilitator can get session resources" do
    facilitator = %{id: 1, role: "facilitator"}
    SessionResourcesPermissions.can_get_resources(facilitator)
    |> assert
  end

  test "participant can't get session resources" do
    participant = %{id: 2, role: "participant"}
    SessionResourcesPermissions.can_get_resources(participant)
    |> refute
  end

end
