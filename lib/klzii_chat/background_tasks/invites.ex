defmodule KlziiChat.BackgroundTasks.Invites do
  alias KlziiChat.{Endpoint, Invite}
  alias KlziiChat.{Repo}

  def perform(invite_id, sessionId, type) do
    notify_listeners(invite_id, sessionId, type)
  end


  def notify_listeners(invite_id, session_id, "DELETE") do
    Endpoint.broadcast!("sessionsBuilder:#{session_id}", "inviteDelete", %{id: invite_id})
    {:ok}
  end
  def notify_listeners(invite_id, _, _) do
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
  end\
end
