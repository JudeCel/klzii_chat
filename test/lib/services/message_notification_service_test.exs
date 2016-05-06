defmodule KlziiChat.Services.MessageNotificationServiceTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.MessageNotificationService

  test "group topics and scopes" do

    list = [
      %{"id" => 3, "topic" => %{1 => %{"normal" => 2}}},
      %{"id" => 3, "topic" => %{1 => %{"replay" => 5}}},
      %{"id" => 3, "topic" => %{2 => %{"normal" => 1}}},
      %{"id" => 3, "topic" => %{2 => %{"replay" => 2}}},
      %{"id" => 1, "topic" => %{1 => %{"normal" => 7}}},
    ]
    resp = MessageNotificationService.group_by_topics_and_scope(list)

    result = %{
      "3" => %{"topics" =>  %{ "1" => %{"normal" => 2, "replay" => 5 },
                               "2" => %{"normal" => 1, "replay" => 2 } }
              },
      "1" => %{"topics" =>  %{ "1" => %{"normal" => 7 } } }
    }
    assert(resp == result)
  end

  test "add summary to map by message scope" do
    map = %{
      "3" => %{"topics" =>  %{ "1" => %{"normal" => 2, "replay" => 5 },
                               "2" => %{"normal" => 1, "replay" => 2 } }
              },
      "1" => %{"topics" =>  %{ "1" => %{"normal" => 7 } } }
    }
    result = %{
      "3" => %{"topics" =>  %{ "1" => %{"normal" => 2, "replay" => 5 },
                               "2" => %{"normal" => 1, "replay" => 2 } },
              "summary" => %{"normal" => 3, "replay" => 7 }},
      "1" => %{"topics" =>  %{ "1" => %{"normal" => 7 }},
              "summary" => %{"normal" => 7, "replay" => 0 }}
    }
    resp = MessageNotificationService.calculate_summary(map)
    assert(resp == result)
  end

  test "find diff " do
    MessageNotificationService.find_diff([1,2], [2]) == [1]
  end
end
