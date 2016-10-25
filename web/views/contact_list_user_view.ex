defmodule KlziiChat.ContactListUserView do
  use KlziiChat.Web, :view

  def render("report.json", %{contact_list_user: contact_list_user})do
    %{
      id: contact_list_user.id,
      customFields: contact_list_user.customFields
    }
  end

  defp contact_list_users(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp contact_list_users(contact_list_users), do: contact_list_users

end
