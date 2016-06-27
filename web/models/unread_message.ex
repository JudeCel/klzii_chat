defmodule KlziiChat.UnreadMessage do
  use KlziiChat.Web, :model

  schema "UnreadMessages" do
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :message, KlziiChat.Message, [foreign_key: :messageId]
    field :scope, :string, default: "normal"
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
    |> cast(params, [:sessionMemberId, :sessionTopicId, :messageId, :scope])
    |> validate_required([:sessionMemberId, :sessionTopicId, :messageId, :scope])
    |> validate_length(:body, min: 1)
  end

  # Allowed scopes for this model
  def scopes, do:  %{normal: "normal", reply: "reply"}
end
