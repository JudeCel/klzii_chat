defmodule KlziiChat.Services.SessionMembersServiceTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.SessionMembersService

  test "group_by_role" do

    members = [
      %{id: 1, role: "facilitator", username: "1", colour: "a", online: true, avatarData: "q", ghost: false, sessionTopicContext: %{}, currentTopic: {}, account_user: %{ firstName: "name1", lastName: "name2"}},
      %{id: 2, role: "observer", username: "2", colour: "b", online: false, avatarData: "w", ghost: false, sessionTopicContext: %{}, currentTopic: {}, account_user: %{ firstName: "name1", lastName: "name2"} },
      %{id: 3, role: "participant", username: "3", colour: "c", online: true, avatarData: "e", ghost: false, sessionTopicContext: %{}, currentTopic: {}, account_user: %{ firstName: "name1", lastName: "name2"} }
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
