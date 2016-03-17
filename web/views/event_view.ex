defmodule KlziiChat.EventView do
  use KlziiChat.Web, :view
  alias KlziiChat.SessionMembersView
  alias KlziiChat.Services.Permissions.Events, as: EventPermissions
  alias KlziiChat.Decorators.EventDecorator

  @spec render(String.t, Map.t) :: Map.t
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

  @spec render(String.t, Map.t) :: Map.t
  def render("event.json", %{event: event, member: member}) do
    %{
      id: event.id,
      session_member: SessionMembersView.render("member.json", %{member: event.session_member}),
      event: event.event,
      tag: event.tag,
      replyId: event.replyId,
      time: event.createdAt,
      star: event.star,
      replies: Enum.map(event.replies, fn r ->
        render("event.json", %{event: r, member: member})
      end),
      votes_count: EventDecorator.votes_count(event.votes),
      has_voted: EventDecorator.has_voted(event.votes, member.id),
      permissions: %{
        can_edit: EventPermissions.can_edit(member, event),
        can_delete: EventPermissions.can_delete(member, event),
        can_star: EventPermissions.can_star(member),
        can_vote: EventPermissions.can_vote(member),
        can_reply: (!event.replyId && EventPermissions.can_reply(member)),
        can_new_message: EventPermissions.can_new_message(member)
      }
    }
  end
end
