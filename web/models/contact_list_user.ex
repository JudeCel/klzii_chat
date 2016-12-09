defmodule KlziiChat.ContactListUser do
  use KlziiChat.Web, :model

  schema "ContactListUsers" do
    belongs_to :contact_list, KlziiChat.ContactList, [foreign_key: :contactListId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    belongs_to :user, KlziiChat.User, [foreign_key: :userId]
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    field :customFields, :map
    field :unsubscribeToken, Ecto.UUID
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
