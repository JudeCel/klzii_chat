defmodule KlziiChat.ContactListUserView do
  use KlziiChat.Web, :view

  def render("report.json", %{contact_list_user: contact_list_user})do
    %{
      id: contact_list_user.id,
      account_user: Phoenix.View.render_one(account_user(contact_list_user.account_user), KlziiChat.AccountUserView, "show.json", as: :account_user),
      customFields: contact_list_user.customFields
    }
  end

  defp account_user(%{__struct__: Ecto.Association.NotLoaded}), do: nil
  defp account_user(account_user), do: account_user

end
