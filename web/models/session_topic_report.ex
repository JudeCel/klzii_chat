defmodule KlziiChat.SessionTopicReport do
  use KlziiChat.Web, :model

  schema "SessionTopicsReports" do
    belongs_to :session_member, KlziiChat.SessionMember, [foreign_key: :sessionMemberId]
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    belongs_to :resource, KlziiChat.Resource, [foreign_key: :resourceId]
    field :type, :string
    field :facilitator, :boolean
    field :format, :string
    field :status, :string, default: "progress"
    field :message, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @required_fields ~w(session_member session_topic type facilitator format status)
  @optional_fields ~w(resource message)

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
