defmodule KlziiChat.SessionResource do
  use KlziiChat.Web, :model

  schema "SessionResources" do
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  @required_fields ~w(resourceId sessionId)
  @optional_fields ~w()

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
