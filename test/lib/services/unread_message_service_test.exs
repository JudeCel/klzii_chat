defmodule KlziiChat.Services.UnreadMessageServiceTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.UnreadMessageService

  test "group session topics and scopes" do

    list = [
      %{"id" => 3, "session_topic" => {1, %{"normal" => 2}}},
      %{"id" => 3, "session_topic" => {1, %{"reply" => 5}}},
      %{"id" => 3, "session_topic" => {2, %{"normal" => 1}}},
      %{"id" => 3, "session_topic" => {2, %{"reply" => 2}}},
      %{"id" => 3, "session_topic" => {nil, %{nil => nil}}},
      %{"id" => 1, "session_topic" => {1, %{"normal" => 7}}},
      %{"id" => 1, "session_topic" => {nil, %{nil => 0}}},
    ]
    resp = UnreadMessageService.group_by_session_topics_and_scope(list)

    result = %{
      "3" => %{"session_topics" =>  %{ "1" => %{"normal" => 2, "reply" => 5 },
                               "2" => %{"normal" => 1, "reply" => 2 } }
              },
      "1" => %{"session_topics" =>  %{ "1" => %{"normal" => 7 } } }
    }
    assert(resp == result)
  end

  test "add summary to map by message scope" do
    map = %{
      "3" => %{"session_topics" =>  %{ "1" => %{"normal" => 2, "reply" => 5 },
                               "2" => %{"normal" => 1, "reply" => 2 } }
              },
      "1" => %{"session_topics" =>  %{ "1" => %{"normal" => 7 } } }
    }
    result = %{
      "3" => %{"session_topics" =>  %{ "1" => %{"normal" => 2, "reply" => 5 },
                               "2" => %{"normal" => 1, "reply" => 2 } },
              "summary" => %{"normal" => 3, "reply" => 7 }},
      "1" => %{"session_topics" =>  %{ "1" => %{"normal" => 7 }},
              "summary" => %{"normal" => 7, "reply" => 0 }}
    }
    resp = UnreadMessageService.calculate_summary(map)
    assert(resp == result)
  end
end
