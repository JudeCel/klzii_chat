defmodule KlziiChat.Services.Reports.Types.Statistic.DataContainer do
  alias KlziiChat.Services.Report.DataContainers.ContactListUsers, as: ContactListUsersDataContainers

  def start_link(data) do
    ContactListUsersDataContainers.start_link(data)
  end

  def get_value("First Name", {_, _, username, _}, %{anonymous: false},_) do
    username
  end
  def get_value("First Name", {account_user_id, _, _}, _, container) do
    {:ok, value} = ContactListUsersDataContainers.get_key(container, "firstName", account_user_id)
    value
  end
  def get_value("Anonymous", {_, _, username, _},_, _) do
    username
  end
  def get_value(key,{account_user_id, _, _, _}, _session, container) do
    # This is ok if raise error
    {:ok, value} = ContactListUsersDataContainers.get_key(container, key, account_user_id)
    value
  end
end
