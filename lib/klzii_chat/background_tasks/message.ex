defmodule KlziiChat.BackgroundTasks.Message do
  alias KlziiChat.Services.{UnreadMessageService, SessionMembersService, NotificationService}
  alias KlziiChat.{Endpoint}
  alias KlziiChat.BackgroundTasks.{General}

  def new(message_id)  do
    General.run_task(fn -> process_new_message(message_id)end)
  end

  def read(session_member_id, session_id, message_id)  do
    General.run_task(fn -> process_read_message(session_member_id, session_id, message_id)end)
  end

  def update_has_messages(session_member_id, session_topic_id, new_message) do
    General.run_task(fn -> SessionMembersService.update_has_messages(session_member_id, session_topic_id, new_message) end)
  end

  def send_notification(session_member_id, session_id, active_users, type) do
    General.run_task(fn -> process_send_notification(session_member_id, session_id, active_users, type) end)
  end

  def delete(session_id, session_topic_id) do
    General.run_task(fn -> process_delete_message(session_id, session_topic_id) end)
  end

  defp process_read_message(session_member_id, session_id, message_id) do
    UnreadMessageService.delete(session_member_id, message_id)
    UnreadMessageService.refresh_unread(session_member_id, session_id)
  end

  defp process_new_message(message_id) do
    case UnreadMessageService.process_new_message(message_id) do
      {:ok, session_id, unread_messages} ->
        Endpoint.broadcast!("sessions:#{session_id}", "unread_messages", unread_messages)
        _ ->
          :error
    end
  end

  defp process_delete_message(session_id, session_topic_id) do
    case UnreadMessageService.process_delete_message(session_id, session_topic_id) do
      {:ok, session_id, unread_messages} ->
        Endpoint.broadcast!("sessions:#{session_id}", "unread_messages", unread_messages)
        _ ->
          :error
    end
  end

  defp process_send_notification(session_member_id, session_id, active_users, "chat_message") do
    facilitator = List.first(SessionMembersService.find_by_roles(session_id, ["facilitator"]))
    if session_member_id == facilitator.id do
      users = SessionMembersService.find_by_roles(session_id, ["participant", "observer"])
      Enum.each(users, fn(user) -> 
        NotificationService.send_notification_if_need(user.id, active_users, session_id, "chat_message")
      end)
    end
  end

  defp process_send_notification(session_member_id, session_id, active_users, "private_message") do
    NotificationService.send_notification_if_need(session_member_id, active_users, session_id, "private_message")
  end

end
