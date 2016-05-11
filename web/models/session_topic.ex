defmodule KlziiChat.SessionTopic do
  use KlziiChat.Web, :model

  schema "SessionTopics" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :topicId]
    has_one :console, KlziiChat.Console,[foreign_key: :sessionTopicId]
    field :active, :boolean, default: false
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(sessionId topicId active)
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
