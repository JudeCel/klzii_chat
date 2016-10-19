defmodule KlziiChat.ContactList do
  use KlziiChat.Web, :model

  schema "ContactLists" do
    field :name, :string
    field :role, :string
    field :editable, :boolean, default: false
    field :active, :boolean, default: false
    field :defaultFields, {:array, :string}
    field :visibleFields, {:array, :string}
    field :participantsFields, {:array, :string}
    field :customFields, {:array, :string}
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
