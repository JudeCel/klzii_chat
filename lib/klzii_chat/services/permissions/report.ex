defmodule KlziiChat.Services.Permissions.Report do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]


  @spec can_use(Map.t, Map.t) :: {:ok} | {:error, String.t}
#  def can_use(%{role: session_member_role, account_user: %{role: account_user_role}}, %{data: data}) do
  def can_use(session_member, %{data: data}) do
    roles =  ~w(facilitator accountManager)
    (has_role(session_member, roles) && has_allowed_from_subscription(data, "reportingFunctions"))
    |> formate_error
  end
end
