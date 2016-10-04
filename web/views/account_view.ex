defmodule KlziiChat.AccountView do
  use KlziiChat.Web, :view

  def render("show.json", %{account: account})do
    %{
      name: account.name
    }
  end
end
