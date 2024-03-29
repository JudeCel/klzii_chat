defmodule KlziiChat.BrandProjectPreference do
  use KlziiChat.Web, :model
  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "BrandProjectPreferences" do
    field :name, :string
    field :colours, :map
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    has_one :session, KlziiChat.Session, [foreign_key: :brandProjectPreferenceId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
