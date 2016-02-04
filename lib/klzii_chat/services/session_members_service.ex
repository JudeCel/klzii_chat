defmodule KlziiChat.Services.SessionMembersService do
  alias KlziiChat.{Repo, SessionMember, SessionMembersView}
  
  def find_by_token(token) do
    case Repo.get_by(SessionMember, token: token) do
      nil ->
        nil
      sessionMember ->
        Phoenix.View.render(SessionMembersView, "session_member.json", session_member: sessionMember )
    end
  end
end
