defmodule KlziiChat.AccountUser do
  use KlziiChat.Web, :model

  schema "AccountUsers" do
    belongs_to :user, KlziiChat.User, [foreign_key: :UserId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :AccountId]
    field :firstName, :string
    field :lastName, :string
    field :gender, :string
    field :role, :string
    field :email, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(UserId AccountId firstName lastName gender role email)
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
