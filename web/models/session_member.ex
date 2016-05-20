defmodule KlziiChat.SessionMember do
  use KlziiChat.Web, :model

  schema "SessionMembers" do
    field :username, :string
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    has_many :messages, KlziiChat.Message, [foreign_key: :sessionMemberId]
    has_many :shapes, KlziiChat.Shape, [foreign_key: :sessionMemberId]
    has_many :votes, KlziiChat.Vote, [foreign_key: :sessionMemberId]
    field :colour, :string
    field :avatarData, :map, default: %{ base: 0, face: 3, body: 0, hair: 0, desk: 0, head: 0 }
    field :sessionTopicContext, :map, default: %{}
    field :token, :string
    field :role, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  @required_fields ~w(username colour)
  @optional_fields ~w(avatarData sessionTopicContext)

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
