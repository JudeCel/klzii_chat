defmodule KlziiChat.SubscriptionPreference do
  use KlziiChat.Web, :model
  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """
  schema "SubscriptionPreferences" do
    belongs_to :subscription, KlziiChat.Subscription, [foreign_key: :subscriptionId]
    field :data, :map
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
