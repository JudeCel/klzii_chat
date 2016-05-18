defmodule KlziiChat.Services.Permissions.SessionResourcesTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions

  test "facilitator can add session resources" do
    facilitator = %{id: 1, role: "facilitator"}
    SessionResourcesPermissions.can_add_resources(facilitator)
    |> assert
  end

  test "participant can't add session resources" do
    participant = %{id: 2, role: "participant"}
    SessionResourcesPermissions.can_add_resources(participant)
    |> refute
  end


  test "facilitator can remove session resource" do
    facilitator = %{id: 1, role: "facilitator"}
    SessionResourcesPermissions.can_remove_resource(facilitator)
    |> assert
  end

  test "participant can't remove session resource" do
    participant = %{id: 2, role: "participant"}
    SessionResourcesPermissions.can_remove_resource(participant)
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
