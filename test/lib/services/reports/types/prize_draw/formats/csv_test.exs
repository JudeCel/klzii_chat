defmodule KlziiChat.Services.Reports.Types.PrizeDraw.Formats.CsvTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.PrizeDraw
  alias KlziiChat.Services.{SessionReportingService}
  alias KlziiChat.{Survey, SurveyAnswer,SurveyQuestion}

  setup %{session_topic_1: session_topic, facilitator: facilitator, session: session} do
    survey = %Survey{
      accountId: session.accountId,
      name: "string",
      description: "string",
      thanks: "string",
      closed: false,
      url: "string",
      surveyType: "sessionPrizeDraw"
    }|> Repo.insert!

    interest =
       %SurveyQuestion{
      surveyId: survey.id,
      question: "pff3",
      name: "Interest",
      type: "radio",
      answers: [],
      order: 2
    }|> Repo.insert!

    contact_details =
      %SurveyQuestion{
      surveyId: survey.id,
      question: "pff3",
      name: "Contact Details",
      type: "input",
      answers: [],
      order: 4
    }|> Repo.insert!

    %SurveyAnswer{
      surveyId: survey.id,
      answers: %{
        "#{interest.id}" =>  %{"type" =>  "number", "value" =>  0},
        "#{contact_details.id}" =>  %{
          "type" =>  "object",
          "value" => nil,
          "tagHandled" =>  true,
          "contactDetails" =>  %{
            "age" => "45-49",
            "email" => "asda@dfd.lv",
            "gender" => "male",
            "mobile" =>  "+21334444332",
            "lastName" => "sddsd",
            "firstName" => "wwd"
          }},
        "3" => %{"type" => "number", "value"=> 1}},
    }|> Repo.insert!

    %SurveyAnswer{
      surveyId: survey.id,
      answers: %{
        "1" =>  %{"type" =>  "number", "value" =>  1},
        "2" =>  %{
          "type" =>  "object",
          "value" => nil,
          "tagHandled" =>  true,
          "contactDetails" =>  %{
            "age" => "45-49",
            "email" => "asda@dfd.lv",
            "gender" => "male",
            "mobile" =>  "+21334444332",
            "lastName" => "sddsd",
            "firstName" => "wwd"
          }},
        "3" => %{"type" => "number", "value"=> 1}},
    }|> Repo.insert!

    %Survey{
      accountId: session.accountId,
      name: "string",
      description: "string",
      thanks: "string",
      closed: false,
      url: "string",
      surveyType: "sessionContactList"
    }|> Repo.insert!

    Ecto.build_assoc(session, :session_surveys,
      surveyId: survey.id
    ) |> Repo.insert!

    payload_csv =  %{"sessionTopicId" => session_topic.id, "format" => "csv", "type" => "prize_draw", "scopes" => %{} }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, payload_csv)
    {:ok, topic_report_data} = PrizeDraw.Base.get_data(session_report)
    {:ok, topic_report_data: topic_report_data}
  end

  describe "processe_data" do
    test "topic report", %{topic_report_data: topic_report_data} do
      assert({:ok, _} = PrizeDraw.Formats.Csv.processe_data(topic_report_data))
    end

    test " one item", %{topic_report_data: topic_report_data} do
      assert({:ok, result} = PrizeDraw.Formats.Csv.processe_data(topic_report_data))
      data = Agent.get(result.data, &(&1))
      expect_result = [%{"Contact Number" => "+21334444332", "Email" => "asda@dfd.lv",
   "First Name" => "wwd", "Last Name" => "sddsd"}]
    assert(expect_result == data)
    end
  end
end
