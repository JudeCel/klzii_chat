defmodule KlziiChat.SubscriptionPreference do
  use KlziiChat.Web, :model

  schema "SubscriptionPreferences" do
    belongs_to :subscription, KlziiChat.Subscription, [foreign_key: :subscriptionId]
    field :data, :map
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:data, :subscriptionId])
  end
end
