defmodule KlziiChat.Shape do
  use KlziiChat.Web, :model

  schema "Shapes" do
    belongs_to :topic, KlziiChat.Account, [foreign_key: :topicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    field :event, :map
    field :uid, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(topicId uid sessionMemberId event)
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
end
