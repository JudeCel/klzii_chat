defmodule KlziiChat.SessionMember do
  use KlziiChat.Web, :model

  schema "SessionMembers" do
    field :username, :string
    belongs_to :account_user, KlziiChat.AccountUser, [foreign_key: :accountUserId]
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    has_many :events, KlziiChat.Event, [foreign_key: :sessionMemberId]
    has_many :votes, KlziiChat.Vote, [foreign_key: :sessionMemberId]
    field :colour, :integer, default: 6710886
    field :online, :boolean, default: false
    field :avatarData, :map, default: %{ base: 0, face: 3, body: 0, hair: 0, desk: 0, head: 0 }
    field :token, :string
    field :role, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  @required_fields ~w(token username colour online avatarData role)
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
