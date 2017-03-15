defmodule KlziiChat.Services.Reports.Types.PrizeDraw.PrizeDrawTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.PrizeDraw
  alias KlziiChat.Services.SessionReportingService
  alias KlziiChat.{Survey, SurveyAnswer}

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

    %SurveyAnswer{
      surveyId: survey.id,
      answers: %{
        "1" =>  %{"type" =>  "number", "value" =>  0},
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
    {:ok, session_report: session_report}
  end

  describe "format_modeule" do

    test "csv" do
      assert({:ok, PrizeDraw.Formats.Csv} == PrizeDraw.Base.format_modeule("csv"))
    end

    test "not exists" do
      module = "bar"
      assert({:error, "module for format #{module} not found"} == PrizeDraw.Base.format_modeule(module))
    end
  end

  describe "get_data session report" do
    setup %{session_report: session_report} do
      {:ok, data} = PrizeDraw.Base.get_data(session_report)
      {:ok, data: data}
    end

    test "structure", %{data: data} do
      assert(
        %{"session" => session, "header_title" => header_title, "prize_draw_survey" => prize_draw_survey, "fields" => fields} = data
      )

      assert(is_map(session))
      assert(is_bitstring(header_title))
      assert(is_map(prize_draw_survey))
      assert(is_list(fields))
    end

    test "get_session", %{session_report: session_report, session_topic_1: session_topic_1} do
      sessionId = session_topic_1.sessionId
      assert({:ok, %{id: ^sessionId}} = PrizeDraw.Base.get_session(session_report))
    end
  end

  describe "get_prize_draw_survey" do
    test "return statistic for each session members", %{session_report: session_report} do
      assert({:ok, _} = PrizeDraw.Base.get_prize_draw_survey(session_report))
    end
  end
end
