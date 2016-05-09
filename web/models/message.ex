defmodule KlziiChat.Message do
  use KlziiChat.Web, :model

  schema "Messages" do
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :topicId]
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :reply, KlziiChat.Message, [foreign_key: :replyId]
    has_many :replies, KlziiChat.Message, [foreign_key: :replyId, on_delete: :delete_all]
    has_many :votes, KlziiChat.Vote, [foreign_key: :messageId, on_delete: :delete_all]
    field :body, :string
    field :emotion, :integer
    field :star, :boolean, default: false
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(topicId sessionMemberId body)
  @optional_fields ~w(emotion star replyId)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, (@required_fields ++  @optional_fields))
  end
end
