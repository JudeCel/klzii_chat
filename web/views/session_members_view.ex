defmodule KlziiChat.SessionMembersView do
  use KlziiChat.Web, :view
  alias KlziiChat.Services.Permissions.Events, as: EventPermissions

  def render("member.json", %{ member: member}) do
    %{id: member.id,
      username: member.username,
      colour: member.colour,
      online: member.online,
      avatar_info: member.avatar_info,
      role: member.role,
      permissions: %{
        can_new_message: EventPermissions.can_new_message(member)
      }
    }
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
