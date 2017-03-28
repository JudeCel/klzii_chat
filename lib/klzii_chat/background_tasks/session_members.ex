defmodule KlziiChat.BackgroundTasks.SessionMembers do
  alias KlziiChat.{Repo, Endpoint, SessionMember}

  def perform(id, _type) do
    update_session_member(id)
  end

  def update_session_member(id) do
    case Repo.get_by(SessionMember, id: id) do
      nil ->
        :ok
      session_member ->
        Endpoint.broadcast!("sessions:#{session_member.sessionId}", "update_member", session_member)
    end
  end
end
