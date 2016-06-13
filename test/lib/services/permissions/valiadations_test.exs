defmodule KlziiChat.Services.Permissions.ValidationsPermissionsTest do
  use ExUnit.Case, async: true
  alias  KlziiChat.Services.Permissions.Validations
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

  test "brandLogoAndCustomColors" do
    Validations.has_allowed_from_subscription(@subscription_keys, :brandLogoAndCustomColors) |> assert
  end

  test "accessKlzziForum" do
    Validations.has_allowed_from_subscription(@subscription_keys, :accessKlzziForum) |> assert
  end

  test "accessKlzziFocus" do
    Validations.has_allowed_from_subscription(@subscription_keys, :accessKlzziFocus) |> assert
  end

  test "uploadToGallery" do
    Validations.has_allowed_from_subscription(@subscription_keys, :uploadToGallery) |> assert
  end

  test "discussionGuideTips" do
    Validations.has_allowed_from_subscription(@subscription_keys, :discussionGuideTips) |> assert
  end

  test "reportingFunctions" do
    Validations.has_allowed_from_subscription(@subscription_keys, :reportingFunctions) |> assert
  end
end
