defmodule KlziiChat.Services.MiniSurveysReportingService do
  alias KlziiChat.{Repo, MiniSurvey}
  alias KlziiChat.Services.{FileService}
  alias KlziiChat.Decorators.MiniSurveyAnswersDecorator
  alias KlziiChat.Queries.MiniSurvey, as: QueriesMiniSurvey
  # alias Ecto.DateTime

  # import Ecto.Query, only: [from: 2]
  # import KlziiChat.Helpers.StringHelper, only: [double_quote: 1]

  @spec save_report(String.t, atom, integer, boolean) :: {:ok | :error, String.t}
  def save_report(report_name, report_format, session_topic_id, include_facilitator) do
    with {:ok, report_data} <- get_report(report_format, session_topic_id, include_facilitator),
         {:ok, report_file_path} <- FileService.write_report(report_name, report_format, report_data),
    do:  {:ok, report_file_path}
  end

  @spec get_report(atom, integer, boolean) :: {:ok | :error, List.t | Stream.t}
  def get_report(report_format, session_topic_id, include_facilitator) do
    mini_surveys = QueriesMiniSurvey.base_query(session_topic_id) |> Repo.all
    session_topic = Repo.get(SessionTopic, session_topic_id) |> Repo.preload([session: :account])

    case report_format do
      # :txt -> {:ok, get_stream(:txt, mini_surveys, session_topic.session.name, session_topic.name, include_facilitator)}
      # :csv -> {:ok, get_stream(:csv, mini_surveys, session_topic.session.name, session_topic.name, include_facilitator)}
      :pdf ->
        {:ok, get_html(mini_surveys, session_topic)}
      _ -> {:error, "Incorrect report format: " <> to_string(report_format)}
    end
  end

  # @spec get_stream(atom, List.t, String.t, String.t, boolean) :: Stream.t
  # def get_stream(:txt, mini_surveys, session_name, session_topic_name, include_facilitator) do
  #   stream = Stream.map(mini_surveys, &format_survey_txt(&1, include_facilitator))
  #   Stream.concat(["#{session_name} / #{session_topic_name}\r\n\r\n"], stream)
  # end
  #
  # @spec get_stream(atom, List.t, String.t, String.t, boolean) :: Stream.t
  # def get_stream(:csv, mini_surveys, _, _, include_facilitator) do
  #   stream = Stream.map(mini_surveys, &format_survey_csv(&1, include_facilitator))
  #     Stream.concat(["Title,Question,Name,Answer,Date\n\r"], stream)
  # end


  # @spec format_survey_txt(Map.t, boolean) :: List.t
  # def format_survey_txt(%{id: id, title: title, question: question}, facilitator) do
  #   answers =
  #     Enum.map(get_mini_survey_answers(id, facilitator), fn %{answer: %{"type" => answer_type, "value" => answer_value}} ->
  #       {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)
  #       "#{answer_text}\r\n"
  #     end)
  #
  #   ["#{title} / #{question}\r\n" | answers] ++ ["\r\n"]
  # end

  # @spec format_survey_csv(Map.t, boolean) :: List.t
  # def format_survey_csv(%{id: id, title: title, question: question}, facilitator) do
  #   Enum.map(get_mini_survey_answers(id, facilitator), fn %{answer: %{"type" => answer_type, "value" => answer_value}, session_member: %{username: name}, createdAt: date} ->
  #     {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer_type, answer_value)
  #     "#{double_quote(title)},#{double_quote(question)},#{double_quote(name)},#{answer_text},#{double_quote(DateTime.to_string(date))}\r\n"
  #   end)
  # end
  #

  @spec get_html(List.t, %MiniSurvey{} ) :: String.t
  def get_html(mini_surveys, session_topic) do
    # header_title = "Mini Surveys History - #{session_topic.session.account.name} / #{session_topic.session.name}"
    #
    # html_text = Phoenix.View.render_to_string(
    #   KlziiChat.Reporting.PreviewView, "mini_surveys.html",
    #   mini_surveys: mini_surveys,
    #   session_topic_name: session_topic.name,
    #   header_title: header_title,
    #   layout: {KlziiChat.LayoutView, "report.html"}
    # )
  end

  # @spec format_survey_html(Map.t, boolean) :: Map.t
  # def format_survey_html(%{id: id, title: title, question: question}, facilitator) do
  #   answers =
  #     Enum.map(get_mini_survey_answers(id, facilitator), fn %{answer: answer, session_member: session_member, createdAt: date} ->
  #       {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(answer["type"], answer["value"])
  #       %{session_member: session_member, answer: answer_text, date: date}
  #     end)
  #
  #   %{title: title, question: question, answers: answers}
  # end
  #
  # @spec get_mini_survey_answers(integer, boolean) :: List.t
  # def get_mini_survey_answers(survvey_id, true) do
  #   Repo.all(
  #     from msa in MiniSurveyAnswer,
  #     join: sm in assoc(msa, :session_member),
  #     where: msa.miniSurveyId == ^survvey_id,
  #     order_by: [asc: msa.createdAt],
  #     preload: [session_member: sm]
  #   )
  # end
  #
  #
  # @spec get_mini_survey_answers(integer, boolean) :: List.t
  # def get_mini_survey_answers(survvey_id, false) do
  #   Repo.all(
  #     from msa in MiniSurveyAnswer,
  #     join: sm in assoc(msa, :session_member),
  #     where: msa.miniSurveyId == ^survvey_id and sm.role != "facilitator",
  #     order_by: [asc: msa.createdAt],
  #     preload: [session_member: sm]
  #   )
  # end
end
