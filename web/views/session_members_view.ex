defmodule KlziiChat.SessionMembersView do
  use KlziiChat.Web, :view

  def render("session_member.json", %{session_member: session_member}) do
    %{id: session_member.id,
      username: session_member.username,
      online: session_member.online,
      colour: session_member.colour,
      online: session_member.online,
      avatar_info: session_member.avatar_info,
      role: session_member.avatar_info
    }
  end
end
