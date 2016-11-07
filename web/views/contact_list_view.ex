defmodule KlziiChat.ContactListView do
  use KlziiChat.Web, :view

  def render("report.json", %{contact_list: contact_list})do
    %{
      id: contact_list.id,
      defaultFields: contact_list.defaultFields,
      customFields: contact_list.customFields,
      contact_list_users: render_many(contact_list_users(contact_list.contact_list_users), KlziiChat.ContactListUserView, "report.json", as: :contact_list_user)
    }
  end

  defp contact_list_users(%{__struct__: Ecto.Association.NotLoaded}), do: []
  defp contact_list_users(contact_list_users), do: contact_list_users

end
