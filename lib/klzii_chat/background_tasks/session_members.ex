defmodule KlziiChat.BackgroundTasks.SessionMembers do
  alias KlziiChat.{Repo, Endpoint, SessionMember}

  def perform(id, _type) do
    update_session_member(id)
  end

  def update_session_member(id) do
    session_member = Repo.get_by!(SessionMember, id: id)
    Endpoint.broadcast!("sessions:#{session_member.sessionId}", "update_member", session_member)
  end
end
