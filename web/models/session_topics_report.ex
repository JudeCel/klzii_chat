defmodule KlziiChat.SessionTopicsReport do
  use KlziiChat.Web, :model

  schema "SessionTopicsReports" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    field :type, :string
    field :name, :string
    field :includes, :map, default: %{}
    field :format, :string
    field :status, :string, default: "progress"
    field :message, :string, default: nil
    field :includeFields, {:array, :string}, default: []
    field :deletedAt, Timex.Ecto.DateTime, default: nil
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:resourceId, :sessionId, :sessionTopicId, :type, :includes,
      :name, :format, :status, :message, :includeFields]
    )
    |> validate_length(:includeFields, max: 4)
  end
end
