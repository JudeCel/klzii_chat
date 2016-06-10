defmodule KlziiChat.Subscription do
  use KlziiChat.Web, :model

  schema "Subscriptions" do
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    belongs_to :subscriptio_plan, KlziiChat.SubscriptionPlan, [foreign_key: :subscriptionPlanId]
    has_one :subscription_preference, KlziiChat.SubscriptionPreference, [foreign_key: :subscriptionId]
    field :planId, :string
    field :customerId, :string
    field :subscriptionId, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:accountId, :subscriptionId, :subscriptionPlanId, :planId, :customerId, :subscriptionId])
  end
end
