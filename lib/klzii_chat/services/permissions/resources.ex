defmodule KlziiChat.Services.Permissions.Resources do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_delete(member, objects) do
     roles = ~w(facilitator accountManager admin)
     Enum.any?(objects, fn object ->
      has_owner(member, object, :sessionMemberId) ||
      has_role(member.role, roles) ||
      has_owner(member, object, :accountUserId)
    end)
    |> formate_error
  end

  @spec can_delete(Map.t, Map.t) :: Boolean.t
  def can_zip(member, objects) do
    roles = ~w(facilitator accountManager admin)
     Enum.any?(objects, fn object ->
      has_owner(member, object, :sessionMemberId) ||
      has_role(member.role, roles) ||
      has_owner(member, object, :accountUserId)
    end)
    |> formate_error
  end

  @spec can_upload(Map.t, Map.t) :: Boolean.t
  def can_upload(member, preference) do
    roles =  ~w(facilitator accountManager admin)
    (has_role(member.role, roles) && has_allowed_from_subscription(preference, "uploadToGallery"))
    |> formate_error
  end
end
