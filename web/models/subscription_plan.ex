defmodule KlziiChat.SubscriptionPlan do
  use KlziiChat.Web, :model

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
    field :paidSmsCount, :integer
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

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [ :sessionCount,
                      :contactListCount,
                      :recruiterContactListCount,
                      :importDatabase,
                      :brandLogoAndCustomColors,
                      :contactListMemberCount,
                      :accountUserCount,
                      :exportContactListAndParticipantHistory,
                      :exportRecruiterSurveyData,
                      :accessKlzziForum,
                      :accessKlzziFocus,
                      :canInviteObserversToSession,
                      :paidSmsCount,
                      :discussionGuideTips,
                      :whiteboardFunctionality,
                      :reportingFunctions,
                      :uploadToGallery,
                      :availableOnTabletAndMobilePlatforms,
                      :customEmailInvitationAndReminderMessages,
                      :topicCount,
                      :priority,
                      :chargebeePlanId,
                      :surveyCount])
  end
end