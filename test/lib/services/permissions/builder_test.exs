defmodule KlziiChat.Services.Permissions.BuilderPermissionsTest do
    use KlziiChat.{ModelCase, SessionMemberCase}, async: true
  alias KlziiChat.Services.Permissions.Builder
  @subscription_keys %{data: %{
    "importDatabase" =>  true,
    "brandLogoAndCustomColors" =>  true,
    "accessKlzziForum" =>  true,
    "accessKlzziFocus" =>  true,
    "discussionGuideTips" =>  true,
    "whiteboardFunctionality" =>  true,
    "uploadToGallery" =>  true,
    "reportingFunctions" =>  true,
    "availableOnTabletAndMobilePlatforms" =>  true
  }, subscription: %{planId: "free_trial"}}

  test "build basic permissions map", %{session: session} do
    member = %{id: 1, role: "facilitator"}
    %{
      messages: messages,
      resources: resources,
      reports: reports,
      mini_surveys: mini_surveys,
      console: console,
      pinboard: pinboard,
      can_redirect: can_redirect
    } = Builder.buid_map(member, @subscription_keys, session)
    assert(is_map(messages))
    assert(is_map(resources))
    assert(is_map(reports))
    assert(is_map(mini_surveys))
    assert(is_map(console))
    assert(is_map(pinboard))
    assert(is_map(can_redirect))
  end

  test "#KlziiChat.Services.Permissions.Builder, when can find session_member_permissions", %{facilitator: facilitator} do
    {:ok, pemissions} =  Builder.session_member_permissions(facilitator.id)
    assert(is_map(pemissions))
  end

  test "#KlziiChat.Services.Permissions.Builder, when can't find session_member_permissions raise error ", %{facilitator: facilitator} do
    assert_raise(Ecto.NoResultsError, fn ->
     Builder.session_member_permissions(facilitator.id + 999)
   end)
  end
end
