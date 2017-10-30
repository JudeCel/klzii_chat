defmodule KlziiChat.Services.Permissions.Validations do

  @spec has_owner(Map.t, Map.t, Atom.t) :: Boolean.t
  def has_owner(member, object, key) do
    member.id == Map.get(object, key) || false
  end

  # we should use this methods in order to check user's role
  @spec has_role(Map.t, List.t) :: Boolean.t
  def has_role(%{role: session_member_role, account_user: %{role: account_user_role}}, roles) do
    (is_in_list(session_member_role, roles) || is_in_list(account_user_role, roles))
  end

  # ideally this methods should not be used, because it skips account_user.role
  @spec has_role(Map.t, List.t) :: Boolean.t
  def has_role(%{role: session_member_role}, roles) do
     is_in_list(session_member_role, roles)
  end

  @spec is_in_list(String.t, List.t) :: Boolean.t
  def is_in_list(item, items) do
    Enum.any?(items, &(&1 == item))
  end

  @spec has_allowed_from_subscription(Map.t, Atom.t) :: Boolean.t
  def has_allowed_from_subscription(%{admin: true}, _), do: true
  def has_allowed_from_subscription(subscription_preference, key) do
    Map.get(subscription_preference, key, false)
  end
end
