defmodule KlziiChat.SessionTopicReport do
  use KlziiChat.Web, :model

  schema "SessionTopicsReports" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    field :type, :string
    field :facilitator, :boolean
    field :format, :string
    field :status, :string, default: "progress"
    field :message, :string, default: nil
    field :deletedAt, Ecto.DateTime, default: nil
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(session session_topic type facilitator format status message)
  @optional_fields ~w(resource deletedAt)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, (@required_fields ++ @optional_fields))
  end
end
