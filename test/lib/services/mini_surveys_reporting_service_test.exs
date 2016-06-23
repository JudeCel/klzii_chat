defmodule KlziiChat.Services.MiniSurveysReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.MiniSurveysReportingService

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
     {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:00:00Z")
     {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T10:00:00Z")

    mini_survey1 =
      Ecto.build_assoc(
        session_topic_1, :mini_surveys,
        sessionId: session.id,
        sessionTopicId: session_topic_1.id,
        title: "Survey 1",
        question: "Question 1",
        type: "yesNoMaybe",
        createdAt: create_date2
      ) |> Repo.insert!()

     mini_survey2 =
       Ecto.build_assoc(
         session_topic_1, :mini_surveys,
         sessionId: session.id,
         sessionTopicId: session_topic_1.id,
         title: "Survey 2",
         question: "Question 2",
         type: "5starRating",
         createdAt: create_date1
       ) |> Repo.insert!()

    Ecto.build_assoc(
      mini_survey1, :mini_survey_answers,
      sessionMemberId: facilitator.id,
      miniSurveyId: mini_survey1.id,
      answer: %{"type" => "yesNoMaybe", "value" => "3"},
      createdAt: create_date2
    ) |> Repo.insert!()

    answer12 =
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
    ) |> Repo.insert!()

    answer12 = Repo.preload(answer12, [:session_member])

    {:ok, session: session, session_topic: session_topic_1, mini_survey1: mini_survey1, mini_survey2: mini_survey2, answer12: answer12}
  end

  test "Get all Mini Surveys", %{session_topic: session_topic, mini_survey2: mini_survey2} do
    mini_surveys = MiniSurveysReportingService.get_mini_surveys(session_topic.id)

    assert(Enum.count(mini_surveys) == 2)
    assert(List.first(mini_surveys) == mini_survey2)
  end

  test "Get Mini Survey answers - including Facilitator", %{mini_survey1: mini_survey1, mini_survey2: mini_survey2, answer12: answer12} do
    answers = MiniSurveysReportingService.get_mini_survey_answers(mini_survey1.id, true)
    answers2 = MiniSurveysReportingService.get_mini_survey_answers(mini_survey2.id, true)

    assert(Enum.count(answers) == 2)
    assert(Enum.count(answers2) == 1)
    assert(List.first(answers) == answer12)
  end

  test "Get Mini Survey answers - excluding Facilitator", %{mini_survey1: mini_survey1, mini_survey2: mini_survey2, answer12: answer12} do
    assert([answer12] == MiniSurveysReportingService.get_mini_survey_answers(mini_survey1.id, false))
    assert([] == MiniSurveysReportingService.get_mini_survey_answers(mini_survey2.id, false))
  end

  test "Format survey answers: txt stream", %{mini_survey1: mini_survey1} do
    mini_survey_txt =
      MiniSurveysReportingService.format_survey_txt(mini_survey1, false)

    assert(String.contains?(List.first(mini_survey_txt), "Survey 1 / Question 1"))
    assert(String.contains?(List.last(mini_survey_txt), "Yes"))
  end

  test "Format survey answers: csv stream", %{mini_survey2: mini_survey2} do
    [mini_survey_csv] =
      MiniSurveysReportingService.format_survey_csv(mini_survey2, true)
      |> Enum.to_list()

    assert(mini_survey_csv == ~s("Survey 2","Question 2","cool member",1 star,"2016-05-20 10:00:00"\r\n))
  end

  test "Get full TXT report stream", %{session: session, session_topic: session_topic, mini_survey1: mini_survey1} do
    mini_surveys = MiniSurveysReportingService.get_mini_surveys(session_topic.id)
    txt_stream = MiniSurveysReportingService.get_stream(:txt, mini_surveys, session.name, session_topic.name, true) |> Enum.to_list()

    assert(Enum.count(txt_stream) == 3)
    assert(List.first(txt_stream) == "cool session / cool session topic 1\r\n\r\n")
    assert(List.last(txt_stream) == MiniSurveysReportingService.format_survey_txt(mini_survey1, true))
  end

  test "Get full CSV report stream", %{session: session, session_topic: session_topic, mini_survey1: mini_survey1} do
    mini_surveys = MiniSurveysReportingService.get_mini_surveys(session_topic.id)
    csv_stream = MiniSurveysReportingService.get_stream(:csv, mini_surveys, session.name, session_topic.name, true) |> Enum.to_list()

    assert(Enum.count(csv_stream) == 3)
    assert(List.first(csv_stream) == "Title,Question,Name,Answer,Date\n\r")
    assert(List.last(csv_stream) == MiniSurveysReportingService.format_survey_csv(mini_survey1, true))
  end

  test "Format survey answers for HTML: list of maps", %{mini_survey1: mini_survey1, answer12: answer12} do
    surveys = MiniSurveysReportingService.format_survey_html(mini_survey1, true)
    first_answer = List.first(surveys.answers)

    assert(surveys.title == mini_survey1.title)
    assert(surveys.question == mini_survey1.question)
    assert(first_answer.answer == "Yes")
    assert(first_answer.date == answer12.createdAt)
    assert(first_answer.session_member == answer12.session_member)
  end

  test "Get GTML", %{session_topic: session_topic} do
    MiniSurveysReportingService.get_report(:pdf, session_topic.id, true)

    MiniSurveysReportingService.save_report("test", :pdf, session_topic.id, true)


  end
end
