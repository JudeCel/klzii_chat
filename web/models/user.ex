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

  @required_fields ~w(email)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, (@required_fields ++  @optional_fields))
  end

  def seedChangeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(email encryptedPassword), @optional_fields)
  end
end
