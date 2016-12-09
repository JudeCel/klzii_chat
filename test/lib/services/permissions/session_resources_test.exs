defmodule KlziiChat.Services.Permissions.SessionResourcesTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.SessionResources, as: SessionResourcesPermissions

  test "host can add session resources" do
    facilitator = %{id: 1, role: "facilitator"}
    assert( {:ok} = SessionResourcesPermissions.can_add_resources(facilitator))
  end

  test "guest can't add session resources" do
    participant = %{id: 2, role: "participant"}
    assert( {:error, _} = SessionResourcesPermissions.can_add_resources(participant))
  end


  test "host can remove session resource" do
    facilitator = %{id: 1, role: "facilitator"}
    assert( {:ok} = SessionResourcesPermissions.can_remove_resource(facilitator))
  end

  test "guest can't remove session resource" do
    participant = %{id: 2, role: "participant"}
    assert( {:error, _} = SessionResourcesPermissions.can_remove_resource(participant))
  end


  test "host can get session resources" do
    facilitator = %{id: 1, role: "facilitator"}
    assert( {:ok} = SessionResourcesPermissions.can_get_resources(facilitator))
  end

  test "guest can't get session resources" do
    participant = %{id: 2, role: "participant"}
    assert( {:error, _} = SessionResourcesPermissions.can_get_resources(participant))
  end
end
