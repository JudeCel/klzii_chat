defmodule KlziiChat.Services.Permissions.Account do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_add_new(Map.t) :: {:ok} | {:error, String.t}
  def can_add_new(member) do
    roles = ~w(admin)
    has_role(member, roles)
    |> formate_error
  end
end

