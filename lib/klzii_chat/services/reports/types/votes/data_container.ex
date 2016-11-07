defmodule KlziiChat.Services.Reports.Types.Votes.DataContainer do
  alias KlziiChat.Decorators.MiniSurveyAnswersDecorator
  alias KlziiChat.Helpers.DateTimeHelper
  alias KlziiChat.Services.Report.DataContainers.ContactListUsers, as: ContactListUsersDataContainers

  def start_link(data) do
    ContactListUsersDataContainers.start_link(data)
  end

  def get_value("First Name",_mini_survey, _answer, %{session_member: %{username: username}}, _container) do
    username
  end
  def get_value("Title", %{title: title}, _answer, _session, _container) do
    title
  end
  def get_value("Question", %{question: question}, _answer, _session, _container) do
    question
  end
  def get_value("Answer",_, %{answer: %{"type" => type, "value" => value}}, _session, _container) do
    {:ok, answer_text} = MiniSurveyAnswersDecorator.answer_text(type, value)
    answer_text
  end
  def get_value("Date", _, %{createdAt: createdAt}, %{timeZone: time_zone}, _container) do
    DateTimeHelper.report_format(createdAt, time_zone)
  end
  def get_value(key,_, %{session_member: %{account_user_id: account_user_id}}, _session, container) do
    # This is ok if raise error
    {:ok, value} = ContactListUsersDataContainers.get_key(container, key, account_user_id)
    value
  end
end