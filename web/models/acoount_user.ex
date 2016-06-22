defmodule KlziiChat.AccountUser do
  use KlziiChat.Web, :model

  schema "AccountUsers" do
    belongs_to :user, KlziiChat.User, [foreign_key: :UserId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :AccountId]
    has_many :session_members, KlziiChat.SessionMember, [foreign_key: :accountUserId]
    field :firstName, :string
    field :lastName, :string
    field :gender, :string
    field :role, :string
    field :email, :string
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
    |> validate_required([])
  end
end
