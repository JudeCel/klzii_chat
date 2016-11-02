defmodule KlziiChat.Services.SessionMembersServiceTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.SessionMembersService

  test "group_by_role" do

    account_user = %{ firstName: "firstName", lastName: "lastName" }
    members = [
      %{id: 1, account_user: account_user, role: "facilitator", username: "1", colour: "a", online: true, avatarData: "q", sessionTopicContext: %{}, currentTopic: {}},
      %{id: 2, account_user: account_user, role: "observer", username: "2", colour: "b", online: false, avatarData: "w", sessionTopicContext: %{}, currentTopic: {} },
      %{id: 3, account_user: account_user, role: "participant", username: "3", colour: "c", online: true, avatarData: "e", sessionTopicContext: %{}, currentTopic: {} }
    ]
    resp = SessionMembersService.group_by_role(members)
    assert is_map(resp)
    assert is_map(resp["facilitator"])
    assert is_list(resp["observer"])
    assert length(resp["observer"]) == 1
    assert is_list(resp["participant"])
    assert length(resp["participant"]) == 1
  end

  test "merge session topic context when context is empty" do
    emotion = 2
    session_topic_id = 2
    new_context = %{"avatarData" => %{"face" => emotion}}
    key = to_string(session_topic_id)
    expect = %{key => %{"avatarData" => %{"face" => emotion}}}
    result = SessionMembersService.merge_session_topic_context(%{}, new_context, session_topic_id)
    assert(result == expect)
  end

  test "merge session topic context when context exists" do
    session_topic_id = 2
    emotion = 4
    key = to_string(session_topic_id)
    new_context = %{"avatarData" => %{"face" => emotion}}
    expect = %{key => %{"avatarData" => %{"face" => emotion}}}
    current = %{key => %{"avatarData" => %{"face" => 34}}}
    result = SessionMembersService.merge_session_topic_context(current, new_context, session_topic_id)
    assert(result == expect)
  end
end
