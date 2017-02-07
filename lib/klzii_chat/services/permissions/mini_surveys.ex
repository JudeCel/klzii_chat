defmodule KlziiChat.Services.Permissions.MiniSurveys do
  import KlziiChat.Services.Permissions.Validations
  import KlziiChat.Services.Permissions.ErrorsHelper, only: [formate_error: 1]

  @spec can_delete(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_delete(member, _) do
    roles = ["facilitator"]
    has_role(member.role, roles)
    |> formate_error
  end

  @spec can_display_voting(Map.t, Map.t) :: {:ok } | {:error, String.t}
  def can_display_voting(_, object) do
    (has_allowed_from_subscription(object, "voting"))
    |> formate_error
  end

  @spec can_create(Map.t) :: {:ok } | {:error, String.t}
  def can_create(member) do
    roles = ["facilitator"]
    (has_role(member.role, roles))
    |> formate_error
  end

  @spec can_answer(Map.t) :: {:ok } | {:error, String.t}
  def can_answer(member) do
    roles = ["participant"]
    has_role(member.role, roles)
    |> formate_error
  end
end
# {"voting": false, "priority": -1, "secureSsl": true, "topicCount": -1,
# "surveyCount": 1, "paidSmsCount": 0, "planSmsCount": 20, "sessionCount": 1,
# "importDatabase": true, "chargebeePlanId": "free_trial", "pinboardDisplay": true,
# "uploadToGallery": false, "accessKlzziFocus": true, "accessKlzziForum": true,
# "accountUserCount": 1, "contactListCount": 1, "numberOfContacts": -1,
# "privateMessaging": true, "whiteboardDisplay": false, "reportingFunctions": true,
# "discussionGuideTips": true, "exportRecruiterStats": true, "contactListMemberCount": -1,
# "whiteboardFunctionality": false, "brandLogoAndCustomColors": true, "exportRecruiterSurveyData": false,
# "recruiterContactListCount": 1, "canInviteObserversToSession": true, "availableOnTabletAndMobilePlatforms": true,
# "exportContactListAndParticipantHistory": false, "customEmailInvitationAndReminderMessages": true}
