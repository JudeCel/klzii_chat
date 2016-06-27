defmodule KlziiChat.Topic do
  use KlziiChat.Web, :model
  
  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """
  schema "Topics" do
    has_many :session_topics, KlziiChat.SessionTopic, [foreign_key: :topicId]
    has_many :sessions, through: [:session_topics, :sessionId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]

    field :type, :string, default: "chat"
    field :name, :string
    field :description, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [])
  end
end
