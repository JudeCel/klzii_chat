defmodule KlziiChat.Services.Permissions.Resources do
  alias KlziiChat.{Repo, Resource }
  import Ecto.Query, only: [from: 2]
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1, format_limit_error: 2]

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, objects) do
    if objects == [] do
      {:ok}
    else
     roles = ~w(facilitator accountManager admin)
     Enum.any?(objects, fn object ->
       has_owner(member, object, :sessionMemberId) ||
       has_role(member, roles) ||
       has_owner(member, object, :accountUserId)
     end)
     |> formate_error
    end
  end

  @spec can_see_section(Map.t) :: {:ok } | {:error, String.t}
  def can_see_section(member) do
    roles = ~w(facilitator accountManager)
    (has_role(member, roles))
    |> formate_error
  end

  def can_upload_by_scope(member, scope) do
    case KlziiChat.Services.Permissions.Builder.get_subscription_preference_account_user(member.id) do
      {:ok, preference} ->
        can_upload_by_scope(member, preference, scope)
      {:error, reason} ->
        {:error, reason}
    end
  end
  def can_upload_by_scope(member, %{data: data}, "brandLogo") do
    roles =  ~w(facilitator accountManager admin participant)
    account_id = member."AccountId"
    current_count = from(r in Resource,
           where: r.scope == "brandLogo",
           where: r.accountId == ^account_id,
           select: count("*")
         ) |> Repo.one
    can_upload = (has_role(member, roles) && (has_enough_amount_from_subscription(data, "brandLogoAndCustomColors", current_count)))
    format_limit_error(can_upload, "Brand Logos")
  end
  def can_upload_by_scope(member, %{data: data}, _) do
    roles =  ~w(facilitator accountManager admin participant)
    (has_role(member, roles) && has_allowed_from_subscription(data, "uploadToGallery"))
    |> formate_error
  end

  def can_upload(member) do
    case KlziiChat.Services.Permissions.Builder.get_subscription_preference_account_user(member.id) do
      {:ok, preference} ->
        can_upload(member, preference)
      {:error, reason} ->
        {:error, reason}
    end
  end
  def can_upload(member, %{data: data}) do
    roles =  ~w(facilitator accountManager admin participant)
    (has_role(member, roles) && has_allowed_from_subscription(data, "uploadToGallery"))
    |> formate_error
  end
end
