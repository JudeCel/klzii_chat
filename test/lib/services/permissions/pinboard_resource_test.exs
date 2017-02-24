defmodule KlziiChat.Services.Permissions.PinboardResourceTest do
  use ExUnit.Case, async: true
  use KlziiChat.{SessionTypeCase}
  alias KlziiChat.Services.Permissions.PinboardResource

  describe("host") do
    test "can't add resource when session type is focus", %{properties: properties} do
      member = %{id: 1, role: "facilitator"}
      session = %{session_type: %{properties: properties["focus"]}}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't add resource when session type is forum", %{properties: properties} do
      member = %{id: 1, role: "facilitator"}
      session = %{session_type: %{properties: properties["forum"]}}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can enable when session type is focus", %{properties: properties} do
      member = %{id: 1, role: "facilitator"}
      session = %{session_type: %{properties: properties["focus"]}}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:ok} = PinboardResource.can_enable(member, session, preference))
    end

    test "can't enable when session type is forum", %{properties: properties} do
      member = %{id: 1, role: "facilitator"}
      session = %{session_type: %{properties: properties["forum"]}}
      reference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_enable(member, session, reference))
    end

    test "can remove resource" do
      member = %{id: 1, role: "facilitator"}
      object = %{id: 1, sessionMemberId: (member.id + 1)}
      assert({:ok} = PinboardResource.can_remove_resource(member, object))
    end
  end

  describe("guest") do
    test "can add resource when session type is focus", %{properties: properties} do
      member = %{id: 1, role: "participant"}
      session = %{session_type: %{properties: properties["focus"]}}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:ok} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't add resource when session type is forum", %{properties: properties} do
      member = %{id: 1, role: "participant"}
      session = %{session_type: %{properties: properties["forum"]}}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't 'enable when session type is focus", %{properties: properties} do
      member = %{id: 1, role: "participant"}
      session = %{session_type: %{properties: properties["focus"]}}
      reference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_enable(member, session, reference))
    end

    test "can't 'enable when session type is forum", %{properties: properties} do
      member = %{id: 1, role: "participant"}
      session = %{session_type: %{properties: properties["forum"]}}
      reference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_enable(member, session, reference))
    end

    test "can't remove resource when owner" do
      member = %{id: 1, role: "participant"}
      object = %{id: 1, sessionMemberId: member.id}
      assert({:error, _} = PinboardResource.can_remove_resource(member,object))
    end

    test "can't remove resource if not owner" do
      member = %{id: 1, role: "participant"}
      object = %{id: 1, sessionMemberId: (member.id + 1)}
      assert({:error, _} = PinboardResource.can_remove_resource(member,object))
    end
  end

  describe("spectator") do
    test "can't add resource when session type is focus", %{properties: properties} do
      member = %{id: 1, role: "observer"}
      session = %{session_type: %{properties: properties["focus"]}}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't add resource when session type is forum", %{properties: properties} do
      member = %{id: 1, role: "observer"}
      session = %{session_type: %{properties: properties["forum"]}}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't 'enable when session type is focus", %{properties: properties} do
      member = %{id: 1, role: "observer"}
      session = %{session_type: %{properties: properties["focus"]}}
      reference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_enable(member, session, reference))
    end

    test "can't 'enable when session type is forum", %{properties: properties} do
      member = %{id: 1, role: "observer"}
      session = %{session_type: %{properties: properties["forum"]}}
      reference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_enable(member, session, reference))
    end

    test "can remove resource" do
      member = %{id: 1, role: "observer"}
      object = %{id: 1, sessionMemberId: (member.id + 2) }
      assert({:error, _} = PinboardResource.can_remove_resource(member,object))
    end
  end
end
