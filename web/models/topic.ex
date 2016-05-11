defmodule KlziiChat.Topic do
  use KlziiChat.Web, :model

  schema "Topics" do
    has_many :session_topics, KlziiChat.SessionTopic, [foreign_key: :TopicId]
    has_many :shapes, KlziiChat.Shape, [foreign_key: :topicId]
    has_many :messages, KlziiChat.Message, [foreign_key: :topicId]
    has_many :resources, KlziiChat.Resource, [foreign_key: :topicId]
    has_many :sessions, through: [:session_topics, :sessionId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]

    field :type, :string, default: "chat"
    field :name, :string
    field :description, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  @required_fields ~w(accountId type name )
  @optional_fields ~w(description active)

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
