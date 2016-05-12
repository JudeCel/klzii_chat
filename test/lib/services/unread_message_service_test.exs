defmodule KlziiChat.Services.UnreadMessageServiceTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.UnreadMessageService

  test "group topics and scopes" do

    list = [
      %{"id" => 3, "topic" => {1, %{"normal" => 2}}},
      %{"id" => 3, "topic" => {1, %{"reply" => 5}}},
      %{"id" => 3, "topic" => {2, %{"normal" => 1}}},
      %{"id" => 3, "topic" => {2, %{"reply" => 2}}},
      %{"id" => 3, "topic" => {nil, %{nil => nil}}},
      %{"id" => 1, "topic" => {1, %{"normal" => 7}}},
      %{"id" => 1, "topic" => {nil, %{nil => 0}}},
    ]
    resp = UnreadMessageService.group_by_topics_and_scope(list)

    result = %{
      "3" => %{"topics" =>  %{ "1" => %{"normal" => 2, "reply" => 5 },
                               "2" => %{"normal" => 1, "reply" => 2 } }
              },
      "1" => %{"topics" =>  %{ "1" => %{"normal" => 7 } } }
    }
    assert(resp == result)
  end

  test "add summary to map by message scope" do
    map = %{
      "3" => %{"topics" =>  %{ "1" => %{"normal" => 2, "reply" => 5 },
                               "2" => %{"normal" => 1, "reply" => 2 } }
              },
      "1" => %{"topics" =>  %{ "1" => %{"normal" => 7 } } }
    }
    result = %{
      "3" => %{"topics" =>  %{ "1" => %{"normal" => 2, "reply" => 5 },
                               "2" => %{"normal" => 1, "reply" => 2 } },
              "summary" => %{"normal" => 3, "reply" => 7 }},
      "1" => %{"topics" =>  %{ "1" => %{"normal" => 7 }},
              "summary" => %{"normal" => 7, "reply" => 0 }}
    }
    resp = UnreadMessageService.calculate_summary(map)
    assert(resp == result)
  end

  test "find diff " do
    assert(UnreadMessageService.find_diff([7, 2], [2, 4]) == [4, 7])

    assert(UnreadMessageService.find_diff([], [2, 4]) == [2, 4])

    assert(UnreadMessageService.find_diff([1, 3], []) == [1, 3])

    assert(UnreadMessageService.find_diff([1, 3], [3]) == [1])

    assert(UnreadMessageService.find_diff([1, 3], [2]) == [2, 1, 3])
  end
end