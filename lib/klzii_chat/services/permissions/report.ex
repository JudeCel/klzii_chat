defmodule KlziiChat.Services.Permissions.Report do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_use(Map.t, Map.t) :: {:ok} | {:error, String.t}
  def can_use(member, %{data: data}) do
    roles =  ~w(facilitator)
    (has_role(member.role, roles) && has_allowed_from_subscription(data, "reportingFunctions"))
    |> formate_error
  end
end
