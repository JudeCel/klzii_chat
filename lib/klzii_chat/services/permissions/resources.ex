defmodule KlziiChat.Services.Permissions.Resources do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, objects) do
    if objects == [] do
      {:ok}
    else
     roles = ~w(facilitator accountManager admin)
     Enum.any?(objects, fn object ->
       has_owner(member, object, :sessionMemberId) ||
       has_role(member.role, roles) ||
       has_owner(member, object, :accountUserId)
     end)
     |> formate_error
    end
  end

  @spec can_see_section(Map.t) :: {:ok } | {:error, String.t}
  def can_see_section(member) do
    roles = ~w(facilitator)
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_zip(Map.t, Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_zip(member, objects, preference) do
    roles = ~w(facilitator accountManager admin)
     Enum.any?(objects, fn object ->
      (has_owner(member, object, :sessionMemberId) ||
       has_role(member.role, roles) ||
       has_owner(member, object, :accountUserId)
       && has_allowed_from_subscription(preference, "uploadToGallery")
       )
    end)
    |> formate_error
  end

  @spec can_zip(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_zip(member, objects) do
    case KlziiChat.Services.Permissions.Builder.get_subscription_preference_account_user(member.id) do
      {:ok, preference} ->
        can_zip(member, objects, preference)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec can_upload(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_upload(member, preference) do
    roles =  ~w(facilitator accountManager admin participant)
    (has_role(member.role, roles) && has_allowed_from_subscription(preference, "uploadToGallery"))
    |> formate_error
  end

  @spec can_upload(Map.t) :: {:ok } | {:error, String.t}
  def can_upload(member) do
    case KlziiChat.Services.Permissions.Builder.get_subscription_preference_account_user(member.id) do
      {:ok, preference} ->
        can_upload(member, preference)
      {:error, reason} ->
        {:error, reason}
    end
  end
end
