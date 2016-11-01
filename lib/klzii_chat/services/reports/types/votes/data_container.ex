defmodule KlziiChat.Services.Reports.Types.Votes.DataContainer do
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.DateTimeHelper
  alias KlziiChat.Services.Report.DataContainers.ContactListUsers, as: ContactListUsersDataContainers

  def start_link(data) do
    ContactListUsersDataContainers.start_link(data)
  end

  def get_value("First Name", _, _,_) do
    "First Name"
  end
  def get_value("Title", %{title: title}, _,_) do
    title
  end
  def get_value("Question", %{question: question}, _,_) do
    question
  end
  def get_value("Answer", _, _,_) do
    "Answer"
  end
  def get_value("Date", _, %{timeZone: time_zone},_) do
    "Answer createdAt"
    # DateTimeHelper.report_format(createdAt, time_zone)
  end
  def get_value(key, %{session_member: %{account_user_id: account_user_id}}, _, container) do
    # This is ok if raise error
    {:ok, value} = ContactListUsersDataContainers.get_key(container, key, account_user_id)
    value
  end
end
