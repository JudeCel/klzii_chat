defmodule KlziiChat.Event do
  use KlziiChat.Web, :model

  schema "Events" do
    belongs_to :accountUser, KlziiChat.User, [foreign_key: :accountUserId]
    belongs_to :topic, KlziiChat.Account, [foreign_key: :topicId]
    field :event, :map
    field :timestamp, Ecto.Time
    # timestamps
  end

  @required_fields ~w(accountUserId event timestamp)
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
