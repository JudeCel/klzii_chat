defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.StatisticTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.Statistic

  describe "#ap_answers" do
    test "build answer data structur" do
      answers = [
        %{
          "10" => %{},
          "6" => %{"type" => "number", "value" => 1},
          "7" => %{"type" => "number", "value" => 0},
          "8" => %{"type" => "string", "value" => "xfcb"},
          "9" => %{"type" => "number", "value" => 1}
        },
        %{
          "10" => %{
            "contactDetails" => %{
              "age" => "18-19",
              "email" => "pff@gmail.com",
              "firstName" => "asss",
              "gender" => "male",
              "lastName" => "ssss",
              "mobile" => "+61334344564"
            },
            "tagHandled" => true,
            "type" => "object",
            "value" => nil
          },
          "6" => %{"type" => "number", "value" => 1},
          "7" => %{"type" => "number", "value" => 0},
          "8" => %{"type" => "string", "value" => "xfcb"},
          "9" => %{"type" => "number", "value" => 0}
        },
        %{
          "10" => %{
            "contactDetails" => %{
              "age" => "50-54",
              "email" => "pff@gmail.com",
              "firstName" => "asss",
              "gender" => "female",
              "lastName" => "ssss",
              "mobile" => "+61334344564"
            },
            "tagHandled" => true,
            "type" => "object",
            "value" => nil
          },
          "6" => %{"type" => "number", "value" => 5},
          "7" => %{"type" => "number", "value" => 3},
          "8" => %{"type" => "string", "value" => "pff"},
          "9" => %{"type" => "number", "value" => 0}
        }
      ]

      expect_result = %{
        "10" => %{count: 3,type: "object", values: %{"age" => %{"18-19" => 1, "50-54" => 1}, "gender" => %{"male" => 1, "female" => 1}}},
        "9" => %{count: 3, type: "number", values: %{0 => 2, 1 => 1}},
        "8" => %{count: 3, type: "string",  values: ["xfcb", "xfcb", "pff"]},
        "7" => %{count: 3, type: "number", values: %{0 => 2, 3 => 1}},
        "6" => %{count: 3, type: "number", values: %{1 => 2, 5 => 1}},
      }

      resp = Statistic.map_answers(answers)
      assert(expect_result == resp)

    end
  end
end
