defmodule KlziiChat.Plugs.ExqUiAuth do

  def is_authorized("admin", "qwerty1234"), do: :authorized
  def is_authorized(_user, _password), do: :unauthorized
end
