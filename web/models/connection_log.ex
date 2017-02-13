defmodule KlziiChat.ConnectionLog do
  use KlziiChat.Web, :model

  schema "ConnectionLogs" do
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    belongs_to :user, KlziiChat.User, [foreign_key: :userId]
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    field :responseTime, :integer
    field :level, :string
    field :meta, :map
    field :req, :map
    field :res, :map
    timestamps [inserted_at: :createdAt, updated_at: false]

  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:accountId, :userId, :accountUserId, :responseTime, :level, :meta, :req, :res])
    |> validate_required([:level, :responseTime])
  end
end
