defmodule KlziiChat.Services.Permissions.ErrorsHelper do

  @spec to_boolean(tuple) :: boolean
  def to_boolean({:ok}), do: true
  def to_boolean({:error, _}), do: false

  @spec messages :: Map.t
  def messages do
    %{
      action_not_allowed:  "Action not allowed!"
    }
  end

  @spec formate_error(boolean) :: tuple
  def formate_error(true) do
    {:ok}
  end
  def formate_error(false) do
    {:error, %{permissions: messages().action_not_allowed, code: 403}}
  end
  @spec format_limit_error(boolean, Any.t) :: tuple
  def format_limit_error(true, _) do
    {:ok}
  end
  def format_limit_error(false, scope) do
    {:error, %{permissions: "You have reached limit for #{scope}.", code: 403}}
  end
end
