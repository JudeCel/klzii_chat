defmodule KlziiChat.EventView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionMembersView

  def render("whiteboard_event.json", %{event: event}) do
    %{
      id: event.id,
      event: event.event,
      tag: event.tag,
      replyId: event.replyId,
      time: event.createdAt,
      star: event.star,
    }
  end

  def render("event.json", %{event: event, member_id: member_id}) do
    %{
      id: event.id,
      session_member: SessionMembersView.render("member.json", %{member: event.session_member}),
      event: event.event,
      tag: event.tag,
      replyId: event.replyId,
      time: event.createdAt,
      star: event.star,
      replies: Enum.map(event.replies, fn r ->
        render("event.json", %{event: r, member_id: member_id})
      end),
      votes_count: Enum.count(event.votes),
      has_voted: Enum.any?(event.votes, fn v -> v.sessionMemberId == member_id  end)
    }
  end
end
