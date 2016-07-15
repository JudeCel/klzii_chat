defmodule KlziiChat.Services.Permissions.Builder do
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [to_boolean: 1]
  alias KlziiChat.Queries.SessionMember, as: SessionMemberQueries
  alias KlziiChat.{Repo, SessionMember}
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions
  alias KlziiChat.Services.Permissions.Whiteboard, as: WhiteboardPermissions
  alias KlziiChat.Services.Permissions.PinboardResource, as: PinboardResourcePermissions
  alias KlziiChat.Services.Permissions.Report, as: ReportPermissions
  alias KlziiChat.Services.Permissions.Validations

  @spec error_messages() :: Map.t
  def error_messages do
    %{
      subscription_not_found: "Subscription not found"
    }
  end


  def pinboard_resource(session_member, pinboard_resource) do
    %{
      can_delete: PinboardResourcePermissions.can_remove_resource(session_member, pinboard_resource) |> to_boolean
    }
  end

  @spec session_member_permissions(Integer) :: Map.t
  def session_member_permissions(session_member_id) do
    session_member = Repo.get!(SessionMember, session_member_id)

    case get_subscription_preference_session_memeber(session_member.sessionId) do
      {:ok, preference} ->
        {:ok, buid_map(session_member, preference)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec buid_map(Map.t, Map.t) :: Map.t
  def buid_map(session_member, preference) do
    %{
      messages: %{
        can_new_message: MessagePermissions.can_new_message(session_member) |> to_boolean,
        can_board_message: SessionTopicPermissions.can_board_message(session_member) |> to_boolean ,
      },
      whiteboard: %{
        can_create: Validations.has_allowed_from_subscription(preference, "whiteboardFunctionality"),
        can_new_shape: WhiteboardPermissions.can_new_shape(session_member) |> to_boolean
      },
      resources: %{
        can_upload: ResourcePermissions.can_upload(session_member, preference) |> to_boolean
      },
      reports: %{
        can_report: ReportPermissions.can_use(session_member, preference) |> to_boolean
      },
      pinboard: %{
        can_enable: PinboardResourcePermissions.can_enable(session_member) |> to_boolean,
        can_add_resource: PinboardResourcePermissions.can_add_resource(session_member) |> to_boolean
      }
    }
  end

  @spec get_subscription_preference_session_memeber(Integer.t) :: Map.t
  defp get_subscription_preference_session_memeber(session_member_id) do
    SessionMemberQueries.get_subscription_preference_session_memeber(session_member_id)
      |> Repo.one
      |> case do
        nil ->
          {:error, error_messages.subscription_not_found}
        preference ->
          {:ok, Map.get(preference, :data, %{})}
      end
  end
end
