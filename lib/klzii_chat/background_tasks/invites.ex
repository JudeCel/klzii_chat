defmodule KlziiChat.BackgroundTasks.Invites do
  alias KlziiChat.{Endpoint, Invite}
  alias KlziiChat.{Repo}

  def perform(invite_id) do
    notify_listeners(invite_id)
  end

  def notify_listeners(invite_id) do
    Repo.get(Invite, invite_id)
    |> case  do
        nil ->
          {:error, "Invite not found"}
        %{sessionId: nil} ->
          # Handle only session invites.
          {:error, "unsuported Invite"}
        invite ->
          data = %{id: invite.id, emailStatus: invite.emailStatus, status: invite.status}
          Endpoint.broadcast!("sessionsBuilder:#{invite.sessionId}", "inviteUpdate", data)
          {:ok}
      end
  end
end
