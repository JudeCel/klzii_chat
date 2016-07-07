defmodule KlziiChat.SessionMember do
  use KlziiChat.Web, :model

  @moduledoc """
    For this model allow insert only: username, avatarData, sessionTopicContext  fields
  """

  schema "SessionMembers" do
    field :username, :string
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    has_many :messages, KlziiChat.Message, [foreign_key: :sessionMemberId]
    has_many :shapes, KlziiChat.Shape, [foreign_key: :sessionMemberId]
    has_many :pinboard_resources, KlziiChat.PinboardResource, [foreign_key: :sessionMemberId]
    has_many :votes, KlziiChat.Vote, [foreign_key: :sessionMemberId]
    has_many :sent_direct_messages, KlziiChat.DirectMessage, [foreign_key: :senderId]
    has_many :recieved_direct_messages, KlziiChat.DirectMessage, [foreign_key: :recieverId]
    field :colour, :string
    field :avatarData, :map, default: %{ base: 0, face: 3, body: 0, hair: 0, desk: 0, head: 0 }
    field :sessionTopicContext, :map, default: %{}
    field :token, :string
    field :role, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:username, :avatarData, :sessionTopicContext])
    |> validate_length(:username, min: 1)
  end
end
