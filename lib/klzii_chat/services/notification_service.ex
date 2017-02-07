defmodule KlziiChat.Services.NotificationService do
  alias KlziiChat.{Repo}

  @spec send_notification_if_need(Integer.t, Map.t, Integer.t, String.t) :: {:ok, Boolean.t} | {:error, String.t}
  def send_notification_if_need(session_member_id, active_members, session_id, type) do
    is_active = Map.has_key?(active_members, to_string(session_member_id))
    case is_active do
     false -> 
      check_config_and_send_notification(session_member_id, session_id, type)
     true ->
      {:ok, false}
    end
  end

  defp check_config_and_send_notification(session_member_id, session_id, type) do
    #todo: get account user id and check if need to send
    account_user_id = 0
    
    send_notification(account_user_id, session_id)
  end

  defp send_notification(account_user_id, session_id) do
    case Mix.env do
      :test ->
        {:ok, true}
      _ ->
        #Exq.enqueue(Exq, "emailNotifications", "emailNotifications", [account_user_id, session_id])
        {:ok, true}
    end
  end

end
