defmodule KlziiChat.Services.Permissions.Redirect do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_redirect(Map.t) :: {:ok} | {:error, String.t}
  def can_redirect(member) do
    roles =  ~w(facilitator participant observer)
    has_role(member.role, roles)
    |> formate_error
  end
end
