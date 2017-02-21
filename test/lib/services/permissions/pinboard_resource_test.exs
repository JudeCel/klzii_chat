defmodule KlziiChat.Services.Permissions.PinboardResourceTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.PinboardResource

  describe("host") do
    test "can't add resource when session type is focus" do
      member = %{id: 1, role: "facilitator"}
      session = %{type: "focus"}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't add resource when session type is forum" do
      member = %{id: 1, role: "facilitator"}
      session = %{type: "forum"}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can enable when session type is focus" do
      member = %{id: 1, role: "facilitator"}
      session = %{type: "focus"}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:ok} = PinboardResource.can_enable(member, session, preference))
    end

    test "can't enable when session type is forum" do
      member = %{id: 1, role: "facilitator"}
      session = %{type: "forum"}
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
    test "can add resource when session type is focus" do
      member = %{id: 1, role: "participant"}
      session = %{type: "focus"}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:ok} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't add resource when session type is forum" do
      member = %{id: 1, role: "participant"}
      session = %{type: "forum"}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't 'enable when session type is focus" do
      member = %{id: 1, role: "participant"}
      session = %{type: "focus"}
      reference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_enable(member, session, reference))
    end

    test "can't 'enable when session type is forum" do
      member = %{id: 1, role: "participant"}
      session = %{type: "forum"}
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
    test "can't add resource when session type is focus" do
      member = %{id: 1, role: "observer"}
      session = %{type: "focus"}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't add resource when session type is forum" do
      member = %{id: 1, role: "observer"}
      session = %{type: "forum"}
      preference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_add_resource(member, session, preference))
    end

    test "can't 'enable when session type is focus" do
      member = %{id: 1, role: "observer"}
      session = %{type: "focus"}
      reference = %{data: %{"pinboardDisplay" => true }}
      assert({:error, _} = PinboardResource.can_enable(member, session, reference))
    end

    test "can't 'enable when session type is forum" do
      member = %{id: 1, role: "observer"}
      session = %{type: "forum"}
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
