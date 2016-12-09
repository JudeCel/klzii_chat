defmodule KlziiChat.Services.Reports.Types.Messages.DataContainer do
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
  def get_value("Comment", %{body: body}, _,_) do
    body
  end
  def get_value("Date", %{createdAt: createdAt}, %{timeZone: time_zone},_) do
    DateTimeHelper.report_format(createdAt, time_zone)
  end
  def get_value("Is Reply", %{replyLevel: 0},_,_), do: to_string(false)
  def get_value("Is Reply", _,_,_), do: to_string(true)
  def get_value("Emotion", %{emotion: emotion},_,_) do
    {:ok, emotion_name} = MessageDecorator.emotion_name(emotion)
    emotion_name
  end
  def get_value("Is Star", %{star: star}, _,_), do: to_string(star)
  def get_value(key, %{session_member: %{account_user_id: account_user_id}}, _, container) do
    # This is ok if raise error
    {:ok, value} = ContactListUsersDataContainers.get_key(container, key, account_user_id)
    value
  end
end
