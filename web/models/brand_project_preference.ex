defmodule KlziiChat.BrandProjectPreference do
  use KlziiChat.Web, :model

  schema "BrandProjectPreferences" do
    field :name, :string
    field :colours, :map
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    has_one :session, KlziiChat.Session, [foreign_key: :brandProjectPreferenceId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(name colours accountId)
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
