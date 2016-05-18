defmodule KlziiChat.SessionTopic do
  use KlziiChat.Web, :model

  schema "SessionTopics" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :topicId]
    has_many :messages, KlziiChat.Message, [foreign_key: :sessionTopicId]
    has_many :shapes, KlziiChat.Shape, [foreign_key: :sessionTopicId]
    has_one :console, KlziiChat.Console,[foreign_key: :sessionTopicId]
    field :greetingMessage, :string
    field :name, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(greetingMessage name sessionId topicId active)
  @optional_fields ~w()

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
