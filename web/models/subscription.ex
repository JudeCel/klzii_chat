defmodule KlziiChat.Subscription do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "Subscriptions" do
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    belongs_to :subscriptio_plan, KlziiChat.SubscriptionPlan, [foreign_key: :subscriptionPlanId]
    has_one :subscription_preference, KlziiChat.SubscriptionPreference, [foreign_key: :subscriptionId]
    field :planId, :string
    field :customerId, :string
    field :subscriptionId, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
