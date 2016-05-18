defmodule KlziiChat.SessionMembersView do
  use KlziiChat.Web, :view
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions
  alias KlziiChat.Services.Permissions.SessionTopic, as: SessionTopicPermissions

  def render("member.json", %{ member: member}) do
    %{id: member.id,
      username: member.username,
      colour: member.colour,
      avatarData: member.avatarData,
      role: member.role
    }
  end

  def render("status.json", %{ member: member}) do
    %{
      id: member.id,
      role: member.role
    }
  end

  def render("current_member.json", %{ member: member}) do
    member_map = render("member.json", %{ member: member})
    permissions = %{
      jwt: buildJWT(member),
      account_user_id: member.accountUserId,
      session_id: member.sessionId,
      permissions: %{
        events: %{
          can_new_message: MessagePermissions.can_new_message(member),
          can_board_message: SessionTopicPermissions.can_board_message(member)
        },
        resources: %{
          can_upload: ResourcePermissions.can_upload(member)
        }
      }
    }
    Map.merge(member_map, permissions)
  end

  def render("group_by_role.json", %{ members: members}) do
    accumulator = %{"facilitator" => %{}, "observer" =>  [], "participant" => []}

    Enum.reduce(members, accumulator, fn (member, acc) ->
      member_map = render("member.json", %{ member: member})
      case Map.get(acc, member.role) do
        value when is_map(value) ->
          Map.put(acc, member.role, member_map)
        value when is_list(value) ->
          role_list = Map.get(acc, member.role)
          new_list = role_list ++ [member_map]
          Map.put(acc, member.role, new_list)
      end
    end)
  end

  @spec buildJWT(Map.t) :: Map.t
  defp buildJWT(member) do
    { :ok, jwt, encoded_claims } =  Guardian.encode_and_sign(%KlziiChat.SessionMember{id: member.id})
    jwt
  end
end
