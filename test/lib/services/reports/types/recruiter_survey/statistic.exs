defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.StatisticTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.Statistic

  describe "#ap_answers" do
    test "build answer data structur" do
      answers = [
        %{"10" => %{},
        "6" => %{"type" => "number", "value" => 1},
        "7" => %{"type" => "number", "value" => 0},
        "8" => %{"type" => "string", "value" => "xfcb"},
        "9" => %{"type" => "number", "value" => 1}
        },
        %{"10" => %{"contactDetails" => %{
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
          "6" => %{"type" => "number", "value" => 0},
          "7" => %{"type" => "number", "value" => 0},
          "8" => %{"type" => "string", "value" => "xfcb"},
          "9" => %{"type" => "number", "value" => 0}
        }
      ]

          expect_result = %{
            "10" => %{count: 1,type: "object", values: %{"18-19" => 1}},
            "9" => %{count: 2, type: "number", values: %{0 => 1, 1 => 1}},
            "8" => %{count: 2, type: "string",  values: ["xfcb", "xfcb"]},
            "7" => %{count: 2, type: "number", values: %{0 => 1, 1 => 1}},
            "6" => %{count: 2, type: "number", values: %{0 => 1, 1 => 1}},
          }

          resp = Statistic.map_answers(answers)
          assert(expect_result == resp)

    end
  end
end
