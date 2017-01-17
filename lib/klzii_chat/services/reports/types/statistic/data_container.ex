defmodule KlziiChat.Services.Reports.Types.Statistic.DataContainer do
  alias KlziiChat.Decorators.MessageDecorator
  alias KlziiChat.Helpers.DateTimeHelper
  alias KlziiChat.Services.Report.DataContainers.ContactListUsers, as: ContactListUsersDataContainers

  def start_link(data) do
    ContactListUsersDataContainers.start_link(data)
  end

  def get_value("First Name", %{session_member: %{username: username}},  %{anonymous: false},_) do
    username
  end
  def get_value("First Name", %{session_member: %{role: "facilitator", username: username}},_, _) do
    username
  end
  def get_value("First Name", %{session_member: %{account_user_id: account_user_id}}, _, container) do
    {:ok, value} = ContactListUsersDataContainers.get_key(container, "firstName", account_user_id)
    value
  end
  def get_value("Anonymous", %{session_member: %{role: "facilitator"}},_ ,_) do
    ""
  end
  def get_value("Anonymous", %{session_member: %{username: username}},_ ,_) do
    username
  end
end
