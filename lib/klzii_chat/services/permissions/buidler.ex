defmodule KlziiChat.Services.Permissions.Builder do
  alias KlziiChat.Queries.SessionMember, as: SessionMemberQueries
  alias KlziiChat.{Repo, SessionMember}
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions
  alias KlziiChat.Services.Permissions.Whiteboard, as: WhiteboardPermissions
  alias KlziiChat.Services.Permissions.Validations

  @spec member_permissions(Integer) :: Map.t
  def member_permissions(session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)
    preference = get_subscription_preference(session_member.id)
    buid_map(session_member, preference)
  end

  def buid_map(session_member, preference) do
    %{
      messages: %{
        can_new_message: MessagePermissions.can_new_message(session_member),
        can_board_message: SessionTopicPermissions.can_board_message(session_member),
        can_new_shape: WhiteboardPermissions.can_new_shape(session_member),
      },
      resources: %{
        can_upload: ResourcePermissions.can_upload(session_member, preference)
      },
      reports: %{
        can_report: Validations.has_allowed(preference, :reportingFunctions)
      }
    }
  end

  defp get_subscription_preference(session_member_id) do
    SessionMemberQueries.get_subscription_preference(session_member_id)
      |> Repo.one
      |> case  do
        nil ->
          %{data: %{}}
        preference ->
          Map.get(preference, :data, %{})
      end
  end
end
