defmodule KlziiChat.DirectMessage do
  use KlziiChat.Web, :model

  schema "DirectMessages" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :sender, KlziiChat.SessionMember, [foreign_key: :senderId]
    belongs_to :receiver, KlziiChat.SessionMember, [foreign_key: :recieverId]
    field :readAt, Timex.Ecto.DateTime
    field :text, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:readAt, :sessionId, :senderId, :recieverId, :text])
    |> validate_required([:sessionId, :senderId, :recieverId, :text])
    |> validate_length(:text, min: 1)
  end
end
