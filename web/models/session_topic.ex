defmodule KlziiChat.SessionTopic do
  use KlziiChat.Web, :model

  schema "SessionTopics" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :SessionId]
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :TopicId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  @required_fields ~w(SessionId TopicId)
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
