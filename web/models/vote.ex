defmodule KlziiChat.Vote do
  use KlziiChat.Web, :model

  schema "Votes" do
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :message, KlziiChat.Event, [foreign_key: :messageId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(messageId sessionMemberId)
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
