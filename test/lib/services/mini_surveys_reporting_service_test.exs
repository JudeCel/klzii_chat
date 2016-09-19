defmodule KlziiChat.Services.MiniSurveysReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.MiniSurveysReportingService
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey

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
      ) |> Repo.insert!

     mini_survey2 =
       Ecto.build_assoc(
         session_topic_1, :mini_surveys,
         sessionId: session.id,
         sessionTopicId: session_topic_1.id,
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

    mini_surveys_list =  %{mini_survey1: mini_survey1, mini_survey2: mini_survey2}
    session_topic_with_preload = Repo.preload(session_topic_1, [session: :account])

    {:ok, session: session, session_topic: session_topic_with_preload, mini_surveys_list: mini_surveys_list}
  end

  describe "save_report" do
    test "pdf", %{session_topic: session_topic} do
      assert({:ok, _} = MiniSurveysReportingService.save_report("some_name",:pdf, session_topic.id, false ))
    end

    test "txt", %{session_topic: session_topic} do
      assert({:ok, _} = MiniSurveysReportingService.save_report("some_name",:txt, session_topic.id, false ))
    end

    test "csv", %{session_topic: session_topic} do
      assert({:ok, _} = MiniSurveysReportingService.save_report("some_name", :csv, session_topic.id, false ))
    end
  end

  describe "get_report" do
    test "pdf", %{session_topic: session_topic} do
      assert({:ok, _} = MiniSurveysReportingService.get_report(:pdf, session_topic.id, false ))
    end

    test "txt", %{session_topic: session_topic} do
      assert({:ok, _} = MiniSurveysReportingService.get_report(:txt, session_topic.id, false ))
    end

    test "csv", %{session_topic: session_topic} do
      assert({:ok, _} = MiniSurveysReportingService.get_report(:csv, session_topic.id, false ))
    end
  end

  test "get_html", %{session_topic: session_topic} do
    mini_surveys = QueriesMiniSurvey.report_query(session_topic.id, false) |> Repo.all
    html = MiniSurveysReportingService.get_html(mini_surveys, session_topic)

    Enum.each(mini_surveys, fn(mini_survey) ->
      assert(String.contains?(html, mini_survey.title))
      assert(String.contains?(html, mini_survey.question))

      Enum.each(mini_survey.mini_survey_answers, fn(mini_survey_answer) ->
        assert(String.contains?(html, mini_survey_answer.answer["type"]))
        assert(String.contains?(html, mini_survey_answer.answer["value"]))
      end)

    end)
  end

  test "get_stream :txt", %{session_topic: session_topic} do
    mini_surveys = QueriesMiniSurvey.report_query(session_topic.id, false) |> Repo.all
    [head | _] = MiniSurveysReportingService.get_stream(:txt, mini_surveys, session_topic.session.name, session_topic.name)
    |> Enum.to_list

    assert(String.contains?(head, session_topic.session.name))
    assert(String.contains?(head, session_topic.name))

  end

  test "get_stream :csv", %{session_topic: session_topic} do
    mini_surveys = QueriesMiniSurvey.report_query(session_topic.id, false) |> Repo.all
    [head | _] = MiniSurveysReportingService.get_stream(:csv, mini_surveys, session_topic.session.name, session_topic.name)
    |> Enum.to_list

    ["Title,Question,Name,Answer,Date"]
    |> Enum.each(fn(header_item) ->
      assert(assert(String.contains?(head, header_item)))
    end)
  end

  test "format_survey_txt", %{session_topic: session_topic} do
    mini_survey =
      QueriesMiniSurvey.report_query(session_topic.id, false)
      |> Repo.all
      |> List.last

      txt = MiniSurveysReportingService.format_survey_txt(mini_survey) |> List.first
      assert(String.contains?(txt, mini_survey.question))
      assert(String.contains?(txt, mini_survey.title))
  end

  test "format_survey_csv", %{session_topic: session_topic} do
    mini_survey =
      QueriesMiniSurvey.report_query(session_topic.id, false)
      |> Repo.all
      |> List.last

      txt = MiniSurveysReportingService.format_survey_csv(mini_survey) |> List.first
      assert(String.contains?(txt, mini_survey.question))
      assert(String.contains?(txt, mini_survey.title))
  end
end
