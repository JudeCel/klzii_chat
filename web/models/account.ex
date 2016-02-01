defmodule KlziiChat.Account do
  use KlziiChat.Web, :model

  schema "Accounts" do
    field :name, :string
    has_many :account_users, KlziiChat.AccountUser, [foreign_key: :AccountId]
    has_many :users, through: [:account_users, :user]

    # timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
