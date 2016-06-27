defmodule KlziiChat.Account do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "Accounts" do
    field :name, :string
    has_many :account_users, KlziiChat.AccountUser, [foreign_key: :AccountId]
    has_many :users, through: [:account_users, :user]
    has_many :resources, KlziiChat.Resource, [foreign_key: :accountId]
    has_many :sessions, KlziiChat.Session, [foreign_key: :accountId]
    has_many :topics, KlziiChat.Topic, [foreign_key: :accountId]
    has_one :subscription, KlziiChat.Subscription, [foreign_key: :accountId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
      |> cast(params, [])
  end
end
