defmodule KlziiChat.MiniSurvey do
  use KlziiChat.Web, :model

  schema "MiniSurveys" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :session_topic, KlziiChat.SessionTopic, [foreign_key: :sessionTopicId]
    field :title, :string
    field :question, :string
    field :type, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end


  @required_fields ~w(messageId sessionMemberId)
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
