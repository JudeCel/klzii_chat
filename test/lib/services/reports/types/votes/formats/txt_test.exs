defmodule KlziiChat.Services.Reports.Types.Votes.Formats.TxtTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Votes
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator, participant: participant, contact_list: contact_list} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:00:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T10:00:00Z")

    mini_survey1 =
     Ecto.build_assoc(
       session_topic, :mini_surveys,
       sessionId: session_topic.session.id,
       sessionTopicId: session_topic.id,
       title: "Survey 1",
       question: "Question 1",
       type: "yesNoMaybe",
       createdAt: create_date2
     ) |> Repo.insert!

    mini_survey2 =
      Ecto.build_assoc(
        session_topic, :mini_surveys,
        sessionId: session_topic.session.id,
        sessionTopicId: session_topic.id,
        title: "Survey 2",
        question: "Question 2",
        type: "5starRating",
        createdAt: create_date1
      ) |> Repo.insert!

    Ecto.build_assoc(
      mini_survey1, :mini_survey_answers,
      sessionMemberId: facilitator.id,
      miniSurveyId: mini_survey1.id,
      answer: %{"type" => "yesNoMaybe", "value" => "3"},
      createdAt: create_date2
    ) |> Repo.insert!

     Ecto.build_assoc(
      mini_survey1, :mini_survey_answers,
      sessionMemberId: participant.id,
      miniSurveyId: mini_survey1.id,
      answer: %{"type" => "yesNoMaybe", "value" => "1"},
      createdAt: create_date1
     ) |> Repo.insert!()

    Ecto.build_assoc(
      mini_survey2, :mini_survey_answers,
      sessionMemberId: facilitator.id,
      miniSurveyId: mini_survey2.id,
      answer: %{"type" => "5starRating", "value" => "1"},
      createdAt: create_date2
    ) |> Repo.insert!

    topic_report_payload =  %{"sessionTopicId" => session_topic.id, "format" => "txt",
      "type" => "votes",
      "includeFields" => Enum.concat(["city", "state"], Enum.take(contact_list.customFields, 2))
    }

    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, topic_report_payload)
    {:ok, topic_report_data} = Votes.Base.get_data(topic_report)

    session_report_payload =  %{"format" => "txt", "type" => "votes" }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, session_report_payload)

    {:ok, session_report_data} = Votes.Base.get_data(session_report)
    {:ok, topic_report_data: topic_report_data, session_report_data: session_report_data}
  end

  describe "set date in data accumulator" do
    setup %{topic_report_data: data} do
      fields = get_in(data, ["fields"])
      {:ok, result} = Votes.Formats.Txt.render_string(data)
      {:ok, result: result, fields: fields}
    end

    test "should be list with 4 elements", %{result: result} do
      data = Agent.get(result.data, &(&1))
      assert(Enum.count(data) == 1)
    end

    test "one element contains same all elements from fields lis", %{result: result, fields: fields} do
      data = Agent.get(result.data, &(&1)) |> List.first
      row = String.split(data, ",")
      assert(length(fields) == length(row))
    end
  end
end
