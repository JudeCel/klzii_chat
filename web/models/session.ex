defmodule KlziiChat.Session do
  use KlziiChat.Web, :model

  schema "Sessions" do
    field :name, :string
    field :brand_project_id,  :integer
    field :startTime, Ecto.DateTime
    field :endTime, Ecto.DateTime
    field :incentive_details, :string
    field :active, :boolean
    field :colours_used, :string
    has_many :session_members, KlziiChat.SessionMember, [foreign_key: :sessionId]
    has_many :mini_surveys, KlziiChat.MiniSurvey, [foreign_key: :sessionId]
    belongs_to :brand_project_preference, KlziiChat.BrandProjectPreference, [foreign_key: :brandProjectPreferenceId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    has_many :session_topics, KlziiChat.SessionTopic, [foreign_key: :sessionId]
    has_many :topics, through: [:session_topics, :topic]
    has_many :direct_messages, KlziiChat.DirectMessage, [foreign_key: :sessionId]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]

    # timestamps
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
