defmodule KlziiChat.Event do
  use KlziiChat.Web, :model

  schema "Events" do
    belongs_to :topic, KlziiChat.Account, [foreign_key: :topicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :reply, KlziiChat.Event, [foreign_key: :replyId]
    has_many :replis, KlziiChat.Event, [foreign_key: :replyId]
    field :event, :map
    field :uid, :string
    field :cmd, :string
    field :tag, :string, default: "message"
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(topic topicId event timestamp sessionMemberId)
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
