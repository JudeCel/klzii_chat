defmodule KlziiChat.Services.NotificationService do
  alias KlziiChat.{Repo, SessionMember}
  import Ecto.Query

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
    session_member = 
      (from sm in SessionMember,
        where: sm.id == ^session_member_id,
        preload: [:account_user])
      |> Repo.one

    if session_member.ghost do
      {:ok, false}
    else
      email_notification = session_member.account_user.emailNotification
      if email_notification == "all" || email_notification == "privateMessages" && type == "private_message" do
        send_notification(session_member.account_user.id, session_id)
      else
        {:ok, false}
      end
    end
  end

  defp send_notification(account_user_id, session_id) do
    case Mix.env do
      :test ->
        {:ok, true}
      _ ->
        Exq.enqueue(Exq, "emailNotifications", "emailNotifications", [account_user_id, session_id])
        {:ok, true}
    end
  end

end
