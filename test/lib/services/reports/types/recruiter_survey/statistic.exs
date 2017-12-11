defmodule KlziiChat.Services.Reports.Types.RecruiterSurvey.StatisticTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Reports.Types.RecruiterSurvey.Statistic

  describe "#map_answers" do
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
          "6" => %{"type" => "number", "value" => 2},
          "7" => %{"type" => "number", "value" => 2},
          "8" => %{"type" => "string", "value" => "pff"},
          "9" => %{"type" => "number", "value" => 0}
        }
      ]

      expect_result = %{
        "10" => %{count: 3, values: %{"age" => %{"18-19" => 1, "50-54" => 1}, "gender" => %{"male" => 1, "female" => 1}}},
        "9" => %{count: 3, values: %{0 => 2, 1 => 1}},
        "8" => %{count: 3, values: ["xfcb", "xfcb", "pff"]},
        "7" => %{count: 3, values: %{0 => 2, 2 => 1}},
        "6" => %{count: 3, values: %{1 => 2, 2 => 1}},
      }

      resp = Statistic.map_answers(answers)
      assert(expect_result == resp)

    end
  end
  describe "#map_qestion_list_answers" do
    test "build questions answers from contact list qestions" do
      question_list = [
        %{
          answers: [
            %{"name" => "Brand Name1", "order" => 0},
            %{"name" => "Brand Name2", "order" => 1},
            %{"name" => "Brand Name3", "order" => 2},
            %{"name" => "Don't Know", "order" => 3}],
          id: 6,
          question: "e.g. Which ONE of these is your FIRST choice for (product/service type)?"
        },
        %{
          answers: [
            %{"order" => 0, "placeHolder" => "Answer - 200 Character Limit"}],
            id: 8,
            question: "e.g. What advice would you like to give to (Brand Name) to improve (product/service)?"
          },
        %{answers: [
          %{"contactDetails" => %{
            "age" => %{
              "model" => "age",
              "name" => "Age",
              "options" => [
                "Under 18", "18-19", "20-24", "25-29", "30-34", "35-39",
                "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70+"],
              "order" => 3,
              "select" => true},
            "email" => %{"input" => true, "model" => "email", "name" => "Email",
            "order" => 4},
            "firstName" => %{"input" => true, "model" => "firstName",
            "name" => "First Name", "order" => 0},
            "gender" => %{"model" => "gender", "name" => "Gender",
            "options" => ["male", "female"], "order" => 2, "select" => true},
            "lastName" => %{"input" => true, "model" => "lastName",
            "name" => "Last Name", "order" => 1},
            "mobile" => %{"canDisable" => true, "model" => "mobile",
            "name" => "Mobile", "number" => true, "order" => 5}},
            "handleTag" => "InterestYesTag"}, %{}, %{}, %{}, %{}, %{}],
            id: 10,
            question: "If you answered Yes, please complete your Contact Details"
          }
        ]

      expect_result = [
        %{
          answers: [
            %{name: "Brand Name1", type: "number", count: 0, percents: 0, order: 0},
            %{name: "Brand Name2", type: "number", count: 0, percents: 0, order: 1},
            %{name: "Brand Name3", type: "number", count: 0, percents: 0, order: 2},
            %{name: "Don't Know", type: "number", count: 0, percents: 0, order: 3}
            ],
          id: 6,
          question: "e.g. Which ONE of these is your FIRST choice for (product/service type)?"
        },
        %{
          answers: [
            %{order: 0, type: "list", count: 0, values: []}
          ],
          id: 8,
          question: "e.g. What advice would you like to give to (Brand Name) to improve (product/service)?"
        },
        %{
          id: 10,
          model: "age",
          name: "Age",
            answers: [
              %{count: 0, name: "Under 18", percents: 0, order: "Under 18", type: "number"},
              %{count: 0, name: "18-19", percents: 0,  order: "18-19", type: "number"},
              %{count: 0, name: "20-24", percents: 0,  order: "20-24", type: "number"},
              %{count: 0, name: "25-29", percents: 0,  order: "25-29", type: "number"},
              %{count: 0, name: "30-34", percents: 0,  order: "30-34", type: "number"},
              %{count: 0, name: "35-39", percents: 0,  order: "35-39", type: "number"},
              %{count: 0, name: "40-44", percents: 0,  order: "40-44", type: "number"},
              %{count: 0, name: "45-49", percents: 0,  order: "45-49", type: "number"},
              %{count: 0, name: "50-54", percents: 0,  order: "50-54", type: "number"},
              %{count: 0, name: "55-59", percents: 0,  order: "55-59", type: "number"},
              %{count: 0, name: "60-64", percents: 0,  order: "60-64", type: "number"},
              %{count: 0, name: "65-69", percents: 0,  order: "65-69", type: "number"},
              %{count: 0, name: "70+", percents: 0,  order: "70+", type: "number"}
            ]
        },
        %{
          id: 10,
          model: "gender",
          name: "Gender",
            answers: [
              %{name: "male", type: "number", count: 0, percents: 0, order: "male"},
              %{name: "female", type: "number", count: 0, percents: 0, order: "female"},
            ]
        },
      ]
      resp = Statistic.build_questions(question_list)
      assert(expect_result == resp)
    end

    test "return qestion answer map" do
      question_list = [
        %{
          answers: [
            %{"name" => "Brand Name1", "order" => 0},
            %{"name" => "Brand Name2", "order" => 1},
            %{"name" => "Brand Name3", "order" => 2},
            %{"name" => "Don't Know", "order" => 3}],
          id: 6,
          question: "e.g. Which ONE of these is your FIRST choice for (product/service type)?"
        },
        %{
          answers: [
            %{"name" => "Brand Name", "order" => 0},
            %{"name" => "Brand Name", "order" => 1},
            %{"name" => "Brand Name", "order" => 2},
            %{"name" => "Don't Know", "order" => 3}],
          id: 7,
          question: "e.g. Which ONE of these is your SECOND choice for (product/service type)?"
        },
        %{
          answers: [
            %{"order" => 0, "placeHolder" => "Answer - 200 Character Limit"}],
            id: 8,
            question: "e.g. What advice would you like to give to (Brand Name) to improve (product/service)?"
          },
        %{
          answers: [
            %{"link" => %{
                "name" => "Privace Policy",
                "url" => "https://klzii.com/privacy-policy/"},
              "name" => "Yes - I am aged 18 or over & give you permission to contact me in future about a discussion group",
              "order" => 0,
              "tag" => "InterestYesTag"
            },
            %{"name" => "No", "order" => 1}],
            id: 9,
            question: "e.g. Are you interested in taking part in a future online discussion group"},
        %{answers: [
          %{"contactDetails" => %{
            "age" => %{
              "model" => "age",
              "name" => "Age",
              "options" => [
                "Under 18", "18-19", "20-24", "25-29", "30-34", "35-39",
                "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70+"],
              "order" => 3,
              "select" => true},
            "email" => %{"input" => true, "model" => "email", "name" => "Email",
            "order" => 4},
            "firstName" => %{"input" => true, "model" => "firstName",
            "name" => "First Name", "order" => 0},
            "gender" => %{"model" => "gender", "name" => "Gender",
            "options" => ["male", "female"], "order" => 2, "select" => true},
            "lastName" => %{"input" => true, "model" => "lastName",
            "name" => "Last Name", "order" => 1},
            "mobile" => %{"canDisable" => true, "model" => "mobile",
            "name" => "Mobile", "number" => true, "order" => 5}},
            "handleTag" => "InterestYesTag"}, %{}, %{}, %{}, %{}, %{}],
            id: 10,
            question: "If you answered Yes, please complete your Contact Details"
          }
        ]

        map_answers_result = %{
          "10" => %{count: 2,type: "object", values: %{"age" => %{"18-19" => 1, "50-54" => 1}, "gender" => %{"male" => 1, "female" => 1}}},
          "9" => %{count: 3, type: "number", values: %{0 => 2, 1 => 1}},
          "8" => %{count: 3, type: "string",  values: ["xfcb", "xfcb", "pff"]},
          "7" => %{count: 3, type: "number", values: %{0 => 2, 2 => 1}},
          "6" => %{count: 3, type: "number", values: %{1 => 2, 2 => 1}},
        }

        expect_result = [
          %{
            answers: [
              %{name: "Brand Name1", count: 0, percents: 0.0, order: 0, type: "number"},
              %{name: "Brand Name2", count: 2, percents: 67.0, order: 1, type: "number"},
              %{name: "Brand Name3", count: 1, percents: 33.0, order: 2, type: "number"},
              %{name: "Don't Know", count: 0, percents: 0.0, order: 3, type: "number"}],
            id: 6,
            question: "e.g. Which ONE of these is your FIRST choice for (product/service type)?"
          },
          %{
            answers: [
              %{name: "Brand Name", count: 2, percents: 67.0, order: 0, type: "number"},
              %{name: "Brand Name", count: 0, percents: 0.0, order: 1, type: "number"},
              %{name: "Brand Name", count: 1, percents: 33.0, order: 2, type: "number"},
              %{name: "Don't Know", count: 0, percents: 0.0, order: 3, type: "number"}],
              id: 7,
            question: "e.g. Which ONE of these is your SECOND choice for (product/service type)?"
          },
         %{
            answers: [
              %{count: 3, order: 0, type: "list", percents: 100.0, values: ["xfcb", "xfcb", "pff"]}],
            id: 8,
            question: "e.g. What advice would you like to give to (Brand Name) to improve (product/service)?"
          },
           %{
             answers: [
              %{count: 2, order: 0, type: "number", name: "Yes - I am aged 18 or over & give you permission to contact me in future about a discussion group", percents: 67.0},
              %{count: 1, order: 1, type: "number",name: "No", percents: 33.0}],
            id: 9,
            question: "e.g. Are you interested in taking part in a future online discussion group"
          },
          %{answers: [
            %{count: 0, name: "Under 18", percents: 0.0, order: "Under 18", type: "number"},
            %{count: 1, name: "18-19", percents: 50.0,  order: "18-19", type: "number"},
            %{count: 0, name: "20-24", percents: 0.0,  order: "20-24", type: "number"},
            %{count: 0, name: "25-29", percents: 0.0,  order: "25-29", type: "number"},
            %{count: 0, name: "30-34", percents: 0.0,  order: "30-34", type: "number"},
            %{count: 0, name: "35-39", percents: 0.0,  order: "35-39", type: "number"},
            %{count: 0, name: "40-44", percents: 0.0,  order: "40-44", type: "number"},
            %{count: 0, name: "45-49", percents: 0.0,  order: "45-49", type: "number"},
            %{count: 1, name: "50-54", percents: 50.0,  order: "50-54", type: "number"},
            %{count: 0, name: "55-59", percents: 0.0,  order: "55-59", type: "number"},
            %{count: 0, name: "60-64", percents: 0.0,  order: "60-64", type: "number"},
            %{count: 0, name: "65-69", percents: 0.0,  order: "65-69", type: "number"},
            %{count: 0, name: "70+", percents: 0.0,  order: "70+", type: "number"}],
            id: 10, model: "age", name: "Age"
          },
          %{answers: [
            %{count: 1, name: "male", percents: 50.0, type: "number", order: "male"},
            %{count: 1, name: "female", percents: 50.0, type: "number", order: "female"}],
            id: 10,
            model: "gender",
            name: "Gender",
          }
        ]
        question_list_resp = Statistic.build_questions(question_list)
        resp = Statistic.map_question_list_answers(question_list_resp, map_answers_result)
        assert(expect_result == resp)
    end
  end
end
