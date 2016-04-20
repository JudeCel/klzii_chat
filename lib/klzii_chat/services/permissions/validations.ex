defmodule KlziiChat.Services.Permissions.Validations do

  @spec has_owner(Map.t, Map.t, Atom.t) :: Boolean.t
  def has_owner(member, object, key) do
    member.id == Map.get(object, key) || false
  end

  @spec has_role(String.t, List.t) :: Boolean.t
  def has_role(role, roles) do
    Enum.any?(roles, &(&1 == role))
  end
end
