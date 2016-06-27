defmodule KlziiChat.User do
  use KlziiChat.Web, :model

  schema "Users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encryptedPassword, :string
    has_many :account_users, KlziiChat.AccountUser, [foreign_key: :UserId]
    has_many :accounts, through: [:account_users, :account]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, (@required_fields ++  @optional_fields))
  end
end
