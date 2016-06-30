defmodule KlziiChat.PinboardResource do
  use KlziiChat.Web, :model

  schema "PinboardResources" do
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:sessionTopicId, :sessionMemberId, :resourceId ])
    |> validate_required([:sessionTopicId, :sessionMemberId, :resourceId])
  end
end
