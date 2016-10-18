defmodule KlziiChat.Services.Permissions.Messages do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]
  alias KlziiChat.Services.{MessageService}

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, object) do
    roles = ["facilitator"]
    (has_owner(member, object, :sessionMemberId) || has_role(member.role, roles))
    |> formate_error
  end

  @spec can_new_message(Map.t) :: {:ok } | {:error, String.t}
  def can_new_message(member) do
    roles = ["facilitator", "participant"]
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_edit(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_edit(member, object) do
     has_owner(member, object, :sessionMemberId)
     |> formate_error
  end

  @spec can_vote(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_vote(member, object) do
    roles = ["participant"]
    (has_role(member.role, roles) && !has_owner(member, object, :sessionMemberId))
    |> formate_error
  end

  @spec can_reply(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_reply(member, object) do
    roles = ["facilitator", "participant"]
    (has_role(member.role, roles) and (!object.replyId or (object.session_member.accountUserId != member.account_user_id and !MessageService.get_message(object.replyId).replyId)))
    |> formate_error
  end

  @spec can_star(Map.t) :: {:ok } | {:error, String.t}
  def can_star(member) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end
end
