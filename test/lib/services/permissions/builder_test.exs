defmodule KlziiChat.Services.Permissions.BuilderPermissionsTest do
  use ExUnit.Case, async: true
  alias KlziiChat.Services.Permissions.Builder
  @subscription_keys %{
    importDatabase: true,
    brandLogoAndCustomColors: true,
    accessKlzziForum: true,
    accessKlzziFocus: true,
    discussionGuideTips: true,
    whiteboardFunctionality: true,
    uploadToGallery: true,
    reportingFunctions: true,
    availableOnTabletAndMobilePlatforms: true
  }
  @basic_map %{
    messages: %{},
    resources: %{},
    reports: %{}
  }

  test "build basic permissions map" do
    member = %{id: 1, role: "facilitator"}
    map = Builder.buid_map(member, @subscription_keys)
    assert(@basic_map = map)
  end
end
