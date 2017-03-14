defmodule KlziiChat.Session do
  use KlziiChat.Web, :model

  @moduledoc """
    This Model is read only!
    Not use for insert!
  """

  schema "Sessions" do
    field :name, :string
    field :status, :string
    field :timeZone, :string
    field :brand_project_id, :integer
    field :startTime, Timex.Ecto.DateTime
    field :endTime, Timex.Ecto.DateTime
    field :incentive_details, :string
    field :colours_used, :string
    field :anonymous, :boolean
    has_many :session_members, KlziiChat.SessionMember, [foreign_key: :sessionId]
    has_many :mini_surveys, KlziiChat.MiniSurvey, [foreign_key: :sessionId]
    belongs_to :brand_project_preference, KlziiChat.BrandProjectPreference, [foreign_key: :brandProjectPreferenceId]
    belongs_to :brand_logo, KlziiChat.Resource, [foreign_key: :resourceId]
    belongs_to :account, KlziiChat.Account, [foreign_key: :accountId]
    belongs_to :participant_list, KlziiChat.ContactList, [foreign_key: :participantListId]
    has_many :session_topics, KlziiChat.SessionTopic, [foreign_key: :sessionId]
    has_one :session_survey, KlziiChat.SessionSurvey, [foreign_key: :sessionId]
    has_many :topics, through: [:session_topics, :topic]
    has_many :direct_messages, KlziiChat.DirectMessage, [foreign_key: :sessionId]
    belongs_to :session_type, KlziiChat.SessionType, [foreign_key: :type, references: :name, type: :string]
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
