defmodule KlziiChat.Message do
  use KlziiChat.Web, :model

  schema "Messages" do
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :reply, KlziiChat.Message, [foreign_key: :replyId]
    has_many :replies, KlziiChat.Message, [foreign_key: :replyId, on_delete: :delete_all]
    has_many :unread_messages, KlziiChat.UnreadMessage, [foreign_key: :messageId, on_delete: :delete_all]
    has_many :votes, KlziiChat.Vote, [foreign_key: :messageId, on_delete: :delete_all]
    field :body, :string
    field :replyLevel, :integer, default: 0
    field :emotion, :integer
    field :star, :boolean, default: false
    field :childrenStars, {:array, :integer}, default: []
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:sessionTopicId, :childrenStars, :sessionMemberId, :body, :emotion, :star, :replyId, :replyLevel ])
    |> validate_required([:sessionTopicId, :sessionMemberId, :body, :emotion])
    |> validate_length(:body, min: 1)
  end
end
