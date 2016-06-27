defmodule KlziiChat.Shape do
  use KlziiChat.Web, :model

  schema "Shapes" do
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    field :event, :map
    field :uid, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:sessionTopicId, :uid, :sessionMemberId, :event])
    |> validate_required([:sessionTopicId, :uid, :sessionMemberId, :event])
  end
end
