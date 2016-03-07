defmodule KlziiChat.Services.SessionMembersServiceTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.SessionMembersService

  test "group_by_role" do

    members = [
      %{id: 1, role: "facilitator", username: "1", colour: "a", online: true, avatar_info: "q" },
      %{id: 2, role: "observer", username: "2", colour: "b", online: false, avatar_info: "w" },
      %{id: 3, role: "participant", username: "3", colour: "c", online: true, avatar_info: "e" }
    ]
    resp = SessionMembersService.group_by_role(members)
    assert is_map(resp)
    assert is_map(resp["facilitator"])
    assert is_list(resp["observer"])
    assert length(resp["observer"]) == 1
    assert is_list(resp["participant"])
    assert length(resp["participant"]) == 1
  end
end
