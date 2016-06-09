defmodule KlziiChat.SubscriptionPlan do
  use KlziiChat.Web, :model

  schema "SubscriptionPlans" do
    field :sessionCount, :integer
    field :contactListCount, :integer
    field :additionalContactListCount, :integer
    field :surveyCount, :integer
    field :contactListMemberCount, :integer
    field :participantCount, :integer
    field :observerCount, :integer
    field :paidSmsCount, :integer
    field :priority, :integer
    field :chargebeePlanId, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:sessionCount,
                     :contactListCount,
                     :additionalContactListCount,
                     :surveyCount,
                     :contactListMemberCount,
                     :participantCount,
                     :observerCount,
                     :paidSmsCount,
                     :priority,
                     :chargebeePlanId])
  end
end
