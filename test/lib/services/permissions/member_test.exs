defmodule KlziiChat.Services.Permissions.MemberTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Member

  describe "facilitator" do
    test "when session is anonymous" do
      member = %{id: 1, role: "facilitator"}
      session = %{id: 1, anonymous: true}
      assert( {:ok} = Member.can_change_name(member, session))
    end
  end

  describe "participant" do
    test "when session is anonymous" do
      member = %{id: 1, role: "participant"}
      session = %{id: 1, anonymous: true}
      assert({:error, _} = Member.can_change_name(member, session))
    end
    test "when session not anonymous" do
      member = %{id: 1, role: "participant"}
      session = %{id: 1, anonymous: false}
      assert({:ok} = Member.can_change_name(member, session))
    end
  end

  describe "observer" do
    test "when session is anonymous" do
      member = %{id: 1, role: "observer"}
      session = %{id: 1, anonymous: true}
      assert({:error, _} = Member.can_change_name(member, session))
    end
    test "when session not anonymous" do
      member = %{id: 1, role: "observer"}
      session = %{id: 1, anonymous: false}
      assert({:error, _} = Member.can_change_name(member, session))
    end
  end
end
