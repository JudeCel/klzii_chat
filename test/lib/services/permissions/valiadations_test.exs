defmodule KlziiChat.Services.Permissions.ConsolePermissionsTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Validations
  @subscription_keys %{
    sessionCount: 8,
    contactListCount: 4,
    recruiterContactListCount: 4,
    importDatabase: true,
    brandLogoAndCustomColors: true,
    contactListMemberCount: -1,
    accountUserCount: 5,
    exportContactListAndParticipantHistory: true,
    exportRecruiterSurveyData: true,
    accessKlzziForum: true,
    accessKlzziFocus: true,
    canInviteObserversToSession: true,
    paiedSmsCount: 75,
    discussionGuideTips: true,
    whiteboardFunctionality: true,
    uploadToGallery: true,
    reportingFunctions: true,
    availableOnTabletAndMobilePlatforms: true,
    customEmailInvitationAndReminderMessages: true,
    topicCount: -1,
    priority: 1,
    related: 'senior_yearly'
  }

  test "accessKlzziForum" do
    Validations.has_allowed(@subscription_keys, :accessKlzziForum) |> assert
  end

  test "accessKlzziFocus" do
    Validations.has_allowed(@subscription_keys, :accessKlzziFocus) |> assert
  end

  test "uploadToGallery" do
    Validations.has_allowed(@subscription_keys, :uploadToGallery) |> assert
  end

  test "discussionGuideTips" do
    Validations.has_allowed(@subscription_keys, :discussionGuideTips) |> assert
  end

  test "reportingFunctions" do
    Validations.has_allowed(@subscription_keys, :reportingFunctions) |> assert
  end
end
