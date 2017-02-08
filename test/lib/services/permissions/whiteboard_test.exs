defmodule KlziiChat.Services.Permissions.WhiteboardTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Whiteboard

  test "#Permissions.Whiteboard can_enable" do
    member = %{role: "facilitator"}
    session = %{type: "focus"}
    preference = %{data: %{"whiteboardFunctionality" => true, "whiteboardDisplay" => true}}
    assert({:ok} = Whiteboard.can_enable(member, session,preference))
  end

  test "#Permissions.Whiteboard can_display_whiteboard" do
    preference = %{data: %{"whiteboardFunctionality" => true, "whiteboardDisplay" => true}}
    assert({:ok} = Whiteboard.can_display_whiteboard(preference))
  end

  test "#Permissions.Whiteboard host can delete shape" do
    member = %{id: 1, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 2}
    assert({:ok} = Whiteboard.can_delete(member, shape))
  end

  test "#Permissions.Whiteboard host can erase all" do
    member = %{id: 1, role: "facilitator"}
    assert({:ok} = Whiteboard.can_erase_all(member))
  end

  test "#Permissions.Whiteboard guest can't erase all" do
    member = %{id: 1, role: "participent"}
    assert({:error, _} = Whiteboard.can_erase_all(member))
  end

  test "#Permissions.Whiteboard host can add image" do
    member = %{id: 1, role: "facilitator"}
    assert({:ok} = Whiteboard.can_add_image(member))
  end
  test "#Permissions.Whiteboard guest or observer can't add image" do
    roles = ["observer", "participant"]
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:error, _} = Whiteboard.can_add_image(member))
    end)
  end

  test "#Permissions.Whiteboard owner can delete shape" do
    member = %{id: 1, role: "participant"}
    shape = %{id: 1, sessionMemberId: 1}
    assert({:ok} = Whiteboard.can_delete(member, shape))
  end

  test "#Permissions.Whiteboard owner can edit shape" do
    member = %{id: 1, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 1}
    assert({:ok} = Whiteboard.can_edit(member, shape))
  end

  test "#Permissions.Whiteboard host can edit shape" do
    member = %{id: 2, role: "facilitator"}
    shape = %{id: 1, sessionMemberId: 1}
    assert({:ok} = Whiteboard.can_edit(member, shape))
  end

  test "#Permissions.Whiteboard can new shape when session type is focus" do
    roles = ["facilitator", "participant"]
    preference = %{data: %{"whiteboardFunctionality" =>  true, "whiteboardDisplay" => true}}
    session = %{type: "focus"}
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:ok} = Whiteboard.can_new_shape(member, session, preference))
    end)
  end

  test "#Permissions.Whiteboard can new shape when session type is forum" do
    roles = ["facilitator"]
    session = %{type: "forum"}
    preference = %{data: %{"whiteboardFunctionality" =>  true, "whiteboardDisplay" => true}}

    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:ok} = Whiteboard.can_new_shape(member, session, preference))
    end)
  end

  test "#Permissions.Whiteboard can't new shape when session type is forum" do
    roles = ["participant"]
    session = %{type: "forum"}

    preference = %{data: %{"whiteboardFunctionality" =>  true, "whiteboardDisplay" => true}}
    Enum.map(roles, fn role ->
      member = %{role: role}
      assert({:error, _} = Whiteboard.can_new_shape(member, session, preference))
    end)
  end

  test "#Permissions.Whiteboard can't new shape" do
    sessions = ["forum", "focus"]
    roles = ["observer"]
    preference = %{data: %{"whiteboardFunctionality" =>  true, "whiteboardDisplay" => true}}

    Enum.map(roles, fn role ->
      member = %{role: role}
      Enum.map(sessions, fn type ->
        session = %{type: type}
        assert({:error, _} = Whiteboard.can_new_shape(member, session, preference))
      end)
    end)
  end

  describe "new shape" do
    test "when no whiteboardFunctionality, Host and forum" do
      session = %{type: "forum"}
      member = %{role: "facilitator"}
      preference = %{
        data: %{"whiteboardFunctionality" =>  false, "whiteboardDisplay" => true}
      }
      assert({:ok} = Whiteboard.can_new_shape(member, session, preference))
    end

    test "when no whiteboardFunctionality, Host and focus" do
      session = %{type: "focus"}
      member = %{role: "facilitator"}
      preference = %{
        data: %{"whiteboardFunctionality" =>  false, "whiteboardDisplay" => true}
      }
      assert({:ok} = Whiteboard.can_new_shape(member, session, preference))
    end

    test "when no whiteboardFunctionalit, Guest and forum " do
      session = %{type: "forum"}
      member = %{role: "participant"}
      preference = %{
        data: %{"whiteboardFunctionality" =>  false, "whiteboardDisplay" => true}
      }
      assert({:error, _} = Whiteboard.can_new_shape(member, session, preference))
    end

    test "when no whiteboardFunctionalit, Guest and forum" do
      session = %{type: "forum"}
      member = %{role: "participant"}
      preference = %{
        data: %{"whiteboardFunctionality" =>  false, "whiteboardDisplay" => true}
      }
      assert({:error, _} = Whiteboard.can_new_shape(member, session, preference))
    end

    test "when whiteboardFunctionalit enable, Guest and focus " do
      session = %{type: "focus"}
      member = %{role: "participant"}
      preference = %{
        data: %{"whiteboardFunctionality" =>  true, "whiteboardDisplay" => true}
      }
      assert({:ok} = Whiteboard.can_new_shape(member, session, preference))
    end

    test "when whiteboardFunctionalit enable, Guest and forum" do
      session = %{type: "forum"}
      member = %{role: "participant"}
      preference = %{
        data: %{"whiteboardFunctionality" =>  true, "whiteboardDisplay" => true}
      }
      assert({:error, _} = Whiteboard.can_new_shape(member, session, preference))
    end
  end
end
