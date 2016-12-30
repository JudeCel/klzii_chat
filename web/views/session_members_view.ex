defmodule KlziiChat.SessionMembersView do
  use KlziiChat.Web, :view

  def render("member.json", %{member: member}) do
    %{id: member.id,
      username: member.username,
      colour: member.colour,
      avatarData: member.avatarData,
      sessionTopicContext: member.sessionTopicContext,
      sessionContext: member.sessionContext,
      role: member.role,
      currentTopic: member.currentTopic
    }
  end

  def render("memberfull.json", %{member: member}) do
    %{id: member.id,
      username: member.username,
      colour: member.colour,
      avatarData: member.avatarData,
      sessionTopicContext: member.sessionTopicContext,
      sessionContext: member.sessionContext,
      role: member.role,
      currentTopic: member.currentTopic,
      firstName: member.account_user.firstName,
      lastName: member.account_user.lastName
    }
  end

  def render("status.json", %{ member: member}) do
    %{
      id: member.id,
      role: member.role
    }
  end

  def render("report.json", %{ member: member}) do
    %{
      id: member.id,
      username: member.username,
      colour: member.colour,
      avatarData: member.avatarData,
      sessionTopicContext: member.sessionTopicContext,
      sessionContext: member.sessionContext,
      role: member.role,
      currentTopic: member.currentTopic,
      account_user_id: member.accountUserId,
    }
  end

  def render("current_member.json", %{ member: member, permissions_map: permissions_map}) do
    member_map = render("member.json", %{ member: member})

    current_member_info = %{
      jwt: buildJWT(member),
      account_user_id: member.accountUserId,
      session_id: member.sessionId,
      permissions: permissions_map
    }


    logout_path =
      cond do
        permissions_map.can_redirect.logout ->
          KlziiChat.Router.Helpers.chat_path(KlziiChat.Endpoint, :logout)
        true ->
          nil
      end

    Map.merge(member_map, Map.put(current_member_info, :logout_path, logout_path))
  end

  def render("group_by_role.json", %{ members: members}) do
    accumulator = %{"facilitator" => %{}, "observer" =>  [], "participant" => []}

    Enum.reduce(members, accumulator, fn (member, acc) ->
      member_map = render("memberfull.json", %{ member: member})
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
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(%KlziiChat.SessionMember{id: member.id})
    jwt
  end
end
