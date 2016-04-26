defmodule KlziiChat.SessionMembersView do
  use KlziiChat.Web, :view
  alias KlziiChat.Services.Permissions.Messages, as: MessagePermissions
  alias KlziiChat.Services.Permissions.Resources, as: ResourcePermissions

  def render("member.json", %{ member: member}) do

    %{id: member.id,
      username: member.username,
      colour: member.colour,
      online: member.online,
      avatarData: member.avatarData,
      role: member.role,
      permissions: %{
        events: %{
          can_new_message: MessagePermissions.can_new_message(member)
        },
        resources: %{
          can_upload: ResourcePermissions.can_upload(member)
        }
      }
    }
  end

  def render("current_member.json", %{ member: member}) do
    render("member.json", %{ member: member})
      |> Map.put(:account_user_id, member.accountUserId)
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
end
