defmodule KlziiChat.SubscriptionPlan do
  use KlziiChat.Web, :model

  @moduledoc """
    This Mode is read only!
    Not use for insert!
  """

  schema "SubscriptionPlans" do
    field :sessionCount, :integer
    field :contactListCount, :integer
    field :recruiterContactListCount, :integer
    field :importDatabase, :boolean
    field :brandLogoAndCustomColors, :boolean
    field :contactListMemberCount, :integer
    field :accountUserCount, :integer
    field :exportContactListAndParticipantHistory, :boolean
    field :exportRecruiterSurveyData, :boolean
    field :accessKlzziForum, :boolean
    field :accessKlzziFocus, :boolean
    field :canInviteObserversToSession, :boolean
    field :planSmsCount, :integer
    field :discussionGuideTips, :boolean
    field :whiteboardFunctionality, :boolean
    field :uploadToGallery, :boolean
    field :reportingFunctions, :boolean
    field :availableOnTabletAndMobilePlatforms, :boolean
    field :customEmailInvitationAndReminderMessages, :boolean
    field :topicCount, :integer
    field :priority, :integer
    field :surveyCount, :integer
    field :chargebeePlanId, :string
    timestamps [inserted_at: :createdAt, updated_at: :updatedAt]
  end
end
