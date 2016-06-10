defmodule KlziiChat.Services.Permissions.Resources do
  import KlziiChat.Services.Permissions.Validations

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_delete(member, objects) do
     roles = ~w(facilitator accountManager admin)
     Enum.any?(objects, fn object ->
      has_owner(member, object, :sessionMemberId) ||
      has_role(member.role, roles) ||
      has_owner(member, object, :accountUserId)
    end)
  end

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_zip(member, objects) do
    roles = ~w(facilitator accountManager admin)
     Enum.any?(objects, fn object ->
      has_owner(member, object, :sessionMemberId) ||
      has_role(member.role, roles) ||
      has_owner(member, object, :accountUserId)
    end)
  end

  @spec can_upload(Map.t, Map.t) :: Boolean.t
  def can_upload(member, preference) do
    roles =  ~w(facilitator accountManager admin)
    has_role(member.role, roles)
  end
end
