defmodule KlziiChat.Session do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

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
  end
end
