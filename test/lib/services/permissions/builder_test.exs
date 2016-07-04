defmodule KlziiChat.Services.Permissions.BuilderPermissionsTest do
    use KlziiChat.{ModelCase, SessionMemberCase}, async: true
  alias KlziiChat.Services.Permissions.Builder
  @subscription_keys %{
    "importDatabase" =>  true,
    "brandLogoAndCustomColors" =>  true,
    "accessKlzziForum" =>  true,
    "accessKlzziFocus" =>  true,
    "discussionGuideTips" =>  true,
    "whiteboardFunctionality" =>  true,
    "uploadToGallery" =>  true,
    "reportingFunctions" =>  true,
    "availableOnTabletAndMobilePlatforms" =>  true
  }

  test "build basic permissions map" do
    member = %{id: 1, role: "facilitator"}
    %{ messages: messages, resources: resources, reports: reports } = Builder.buid_map(member, @subscription_keys)
    assert(is_map(messages))
    assert(is_map(resources))
    assert(is_map(reports))
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
