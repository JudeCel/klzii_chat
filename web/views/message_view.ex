defmodule KlziiChat.MessageView do
  use KlziiChat.Web, :view
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [to_boolean: 1]
  alias KlziiChat.SessionMembersView
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  alias KlziiChat.Decorators.MessageDecorator

  @spec render(String.t, Map.t) :: Map.t
  def render("show.json", %{message: message, member: member}) do
    %{
      id: message.id,
      session_member: SessionMembersView.render("member.json", %{member: message.session_member}),
      body: message.body,
      replyId: message.replyId,
      time: message.createdAt,
      star: message.star,
      emotion: message.emotion,
      replies: Enum.map(message.replies, fn r ->
        render("show.json", %{message: r, member: member})
      end),
      votes_count: MessageDecorator.votes_count(message.votes),
      has_voted: MessageDecorator.has_voted(message.votes, member.id),
      unread: MessageDecorator.is_unread(message.unread_messages, member.id),
      permissions: %{
        can_edit: MessagePermissions.can_edit(member, message) |> to_boolean,
        can_delete: MessagePermissions.can_delete(member, message) |> to_boolean,
        can_star: MessagePermissions.can_star(member) |> to_boolean,
        can_vote: MessagePermissions.can_vote(member, message) |> to_boolean,
        can_reply: MessagePermissions.can_reply(member, message) |> to_boolean,
        can_new_message: MessagePermissions.can_new_message(member) |> to_boolean
      }
    }
  end
end
