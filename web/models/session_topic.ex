defmodule KlziiChat.SessionTopic do
  use KlziiChat.Web, :model

  @moduledoc """
    For this model allow insert only: boardMessage, field
  """

  schema "SessionTopics" do
    belongs_to :session, KlziiChat.Session, [foreign_key: :sessionId]
    belongs_to :topic, KlziiChat.Topic, [foreign_key: :topicId]
    has_many :messages, KlziiChat.Message, [foreign_key: :sessionTopicId]
    has_many :shapes, KlziiChat.Shape, [foreign_key: :sessionTopicId]
    has_one :console, KlziiChat.Console,[foreign_key: :sessionTopicId]
    has_many :mini_surveys, KlziiChat.MiniSurvey, [foreign_key: :sessionTopicId]
    field :boardMessage, :string
    field :order, :integer
    field :name, :string
    field :landing, :boolean
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:boardMessage] )
    |> validate_required([:boardMessage])
    |> validate_length(:boardMessage, min: 1, max: 200)
  end
end
