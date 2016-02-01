defmodule KlziiChat.SessionMember do
  use KlziiChat.Web, :model

  schema "sessionMembers" do
    field :username, :string
    belongs_to :user, KlziiChat.User, [foreign_key: :userId]
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    field :colour, :string, default: "0:3:0:0:0:0"
    field :online, :boolean, default: false
    field :avatar_info, :string
    field :role, :string
    # timestamps
  end

  @required_fields ~w(username userId sessionId colour online avatar_info role)
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
