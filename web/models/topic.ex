defmodule KlziiChat.Topic do
  use KlziiChat.Web, :model

  schema "Topics" do
    has_many :session_topics, KlziiChat.SessionTopic, [foreign_key: :TopicId]
    has_many :sessions, through: [:session_topics, :session]


    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    field :type, :string, default: "chat"
    field :name, :string
    field :active, :boolean, default: false
    field :description, :string
  end

  @required_fields ~w( TopicId accountId type name active description )
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
