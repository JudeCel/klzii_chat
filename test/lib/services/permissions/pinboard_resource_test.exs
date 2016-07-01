defmodule KlziiChat.Services.Permissions.PinboardResourceTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.PinboardResource


  describe("facilitator") do
    test "can_add_resource" do
      member = %{id: 1, role: "facilitator"}
      assert({:error, _} = PinboardResource.can_add_resource(member))
    end

    test "can remove resource" do
      member = %{id: 1, role: "facilitator"}
      object = %{id: 1, sessionMemberId: (member.id + 1)}
      assert({:ok} = PinboardResource.can_remove_resource(member, object))
    end
  end

  describe("participent") do
    test "can_add_resource" do
      member = %{id: 1, role: "participant"}
      assert({:ok} = PinboardResource.can_add_resource(member))
    end

    test "can remove resource when owner" do
      member = %{id: 1, role: "participant"}
      object = %{id: 1, sessionMemberId: member.id}
      assert({:ok} = PinboardResource.can_remove_resource(member, object))
    end

    test "can't remove resource if not owner" do
      member = %{id: 1, role: "participant"}
      object = %{id: 1, sessionMemberId: (member.id + 1)}
      assert({:error, _} = PinboardResource.can_remove_resource(member,object))
    end
  end

  describe("observer") do
    test "can set resource" do
      member = %{id: 1, role: "observer"}
      assert({:error, _} = PinboardResource.can_add_resource(member))
    end

    test "can remove resource" do
      member = %{id: 1, role: "observer"}
      object = %{id: 1, sessionMemberId: (member.id + 2) }
      assert({:error, _} = PinboardResource.can_remove_resource(member,object))
    end
  end
end
