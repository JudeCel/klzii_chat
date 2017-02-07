defmodule KlziiChat.Services.Permissions.MiniSurveysTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.MiniSurveys

  describe("host") do
    test "can_delete" do
      member = %{id: 1, role: "facilitator"}
      assert({:ok} = MiniSurveys.can_delete(member, %{}))
    end

    test "can_display_voting" do
      member = %{id: 1, role: "facilitator"}
      preference = %{"voting" => true}
      assert({:ok} = MiniSurveys.can_display_voting(member, preference))
    end

    test "can_create" do
      member = %{id: 1, role: "facilitator"}
      assert({:ok} = MiniSurveys.can_create(member))
    end

    test "can_answer" do
      member = %{id: 1, role: "facilitator"}
      assert({:error, _} = MiniSurveys.can_answer(member))
    end
  end

  describe("guest") do
    test "can_delete" do
      member = %{id: 1, role: "participant"}
      assert({:error, _} = MiniSurveys.can_delete(member, %{}))
    end

    test "can_display_voting" do
      member = %{id: 1, role: "participant"}
      preference = %{"voting" => true}
      assert({:ok} = MiniSurveys.can_display_voting(member, preference))
    end

    test "can_create" do
      member = %{id: 1, role: "participant"}
      assert({:error, _} = MiniSurveys.can_create(member))
    end

    test "can_answer" do
      member = %{id: 1, role: "participant"}
      assert({:ok} = MiniSurveys.can_answer(member))
    end
  end

  describe("spectator") do
    test "can_delete" do
      member = %{id: 1, role: "observer"}
      assert({:error, _} = MiniSurveys.can_delete(member, %{}))
    end

    test "can_display_voting" do
      member = %{id: 1, role: "observer"}
      preference = %{"voting" => true}
      assert({:ok} = MiniSurveys.can_display_voting(member, preference))
    end

    test "can_create" do
      member = %{id: 1, role: "observer"}
      assert({:error, _} = MiniSurveys.can_create(member))
    end

    test "can_answer" do
      member = %{id: 1, role: "observer"}
      assert({:error, _} = MiniSurveys.can_answer(member))
    end
  end
end
