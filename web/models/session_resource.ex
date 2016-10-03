defmodule KlziiChat.SessionResource do
  use KlziiChat.Web, :model
  use Timex.Ecto.Timestamps

  schema "SessionResources" do
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    field :createdAt, Timex.Ecto.DateTime
    field :updatedAt, Timex.Ecto.DateTime
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:resourceId, :sessionId])
  end
end
