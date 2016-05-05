defmodule KlziiChat.OfflineMessage do
  use KlziiChat.Web, :model

  schema "OfflineMessages" do
    belongs_to :topic, KlziiChat.Account, [foreign_key: :topicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :message, KlziiChat.Message, [foreign_key: :messageId]
    field :scope, :string, default: "normal"
    field :createdAt, Timex.Ecto.DateTime
    field :updatedAt, Timex.Ecto.DateTime
    # timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(sessionMemberId topicId messageId)
  @optional_fields ~w(scope)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, (@required_fields ++ @optional_fields))
  end
end
