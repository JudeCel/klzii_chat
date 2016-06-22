defmodule KlziiChat.Services.MiniSurveysReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.MiniSurveysReportingService

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
     {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
     {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:53:00Z")
     {:ok, create_date3} = Ecto.DateTime.cast("2016-05-20T09:57:00Z")

    mini_survey =
      Ecto.build_assoc(
        session_topic_1, :mini_surveys,
        sessionId: session.id,
        sessionTopicId: session_topic_1.id,
        title: "TEST MS 2",
        question: "Test?",
        type: "yesNoMaybe"
      ) |> Repo.insert!()

    # mini_survey2 =
    #   Ecto.build_assoc(
    #     session_topic_1, :mini_surveys,
    #     sessionId: session.id,
    #     sessionTopicId: session_topic_1.id,
    #     title: "TEST",
    #     question: "Test? Test?",
    #     type: "5starRating"
    #   ) |> Repo.insert!()

      Ecto.build_assoc(
        mini_survey, :mini_survey_answers,
        sessionMemberId: facilitator.id,
        miniSurveyId: mini_survey.id,
        answer: %{"type" => "yesNoMaybe", "value" => "3"},
        createdAt: create_date1
      ) |> Repo.insert!()

      Ecto.build_assoc(
        mini_survey, :mini_survey_answers,
        sessionMemberId: participant.id,
        miniSurveyId: mini_survey.id,
        answer: %{"type" => "yesNoMaybe", "value" => "1"},
        createdAt: create_date2
      ) |> Repo.insert!()

      Ecto.build_assoc(
        mini_survey, :mini_survey_answers,
        sessionMemberId: facilitator.id,
        miniSurveyId: mini_survey.id,
        answer: %{"type" => "yesNoMaybe", "value" => "2"},
        createdAt: create_date3
      ) |> Repo.insert!()

      # Ecto.build_assoc(
      #   mini_survey, :mini_survey_answers,
      #   sessionMemberId: facilitator.id,
      #   miniSurveyId: mini_survey.id,
      #   answer: %{"type" => "yesNoMaybe", "value" => "1"}
      # ) |> Repo.insert!()




    {:ok, session_topic: session_topic_1}
  end

  test "get all surveys", %{session_topic: session_topic} do
    [ms] = MiniSurveysReportingService.get_mini_surveys(session_topic.id)
    IO.inspect(ms)
    MiniSurveysReportingService.get_mini_survey_answers(ms.id)
    |> IO.inspect()
  end


end
