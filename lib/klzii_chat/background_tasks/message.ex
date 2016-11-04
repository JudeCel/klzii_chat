defmodule KlziiChat.BackgroundTasks.Message do
  alias KlziiChat.Services.{UnreadMessageService}
  alias KlziiChat.{Endpoint}
  alias KlziiChat.BackgroundTasks.{General}

  def new(message_id)  do
    General.run_task(fn -> process_new_message(message_id)end)
  end

  def read(session_member_id, session_id, message_id)  do
    General.run_task(fn -> process_read_message(session_member_id, session_id, message_id)end)
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

end
