defmodule KlziiChat.Services.ConsoleServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.ConsoleService
  alias KlziiChat.Console

  setup %{session_topic_1: session_topic_1, session: session, account_user_account_manager: account_user} do

     resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "video",
      scope: "collage"
    ) |> Repo.insert!

     youtube_resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "youtube test link ",
      type: "link",
      scope: "collage"
    ) |> Repo.insert!

     mini_survey = Ecto.build_assoc(
      session, :mini_surveys,
      sessionTopicId: session_topic_1.id,
      type: "yesNoMaybe",
      question: "cool question",
      title: "cool title"
    ) |> Repo.insert!

    {:ok, session_id: session.id, youtube_resource: youtube_resource, resource: resource, session_topic_1: session_topic_1.id, mini_survey: mini_survey}
  end

  describe "Console" do
    test "create if not exists", %{session_id: session_id, session_topic_1: session_topic_1} do
      {:ok, first_console} = ConsoleService.get(session_id, session_topic_1)
      {:ok, same_console} = ConsoleService.get(session_id, session_topic_1)
      assert(first_console === same_console )
      assert(%Console{} = same_console )
    end
  end

  describe "Pinboard# " do
   test "can enablable", %{facilitator: facilitator, session_topic_1: session_topic_1} do
      {:ok, console} = ConsoleService.enable_pinboard(facilitator.id, session_topic_1)
      assert(console.pinboard)
   end

   test "when enable then remove all resource", %{facilitator: facilitator, session_topic_1: session_topic_1, resource: resource} do
     {:ok, _} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
     {:ok, console} = ConsoleService.enable_pinboard(facilitator.id, session_topic_1)
     assert(%{audioId: nil, pinboard: true, videoId: nil, fileId: nil, miniSurveyId: nil} = console)
   end
 end

 describe "Resources# " do
   test "add resource", %{facilitator: facilitator, session_topic_1: session_topic_1, resource: resource} do
     {:ok, console} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
     image_id = Map.get(console, String.to_atom(resource.type <> "Id"))
     assert(image_id == resource.id)
     assert(%Console{} = console )
   end

   test "add resource #youtube", %{facilitator: facilitator, session_topic_1: session_topic_1, youtube_resource: resource} do
     {:ok, console} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
     video_id = Map.get(console, String.to_atom("videoId"))
     assert(video_id == resource.id)
     assert(%Console{} = console )
   end

   test "remove resource #youtube", %{facilitator: facilitator, session_topic_1: session_topic_1, youtube_resource: resource} do
     {:ok, _} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
     {:ok, console} = ConsoleService.remove(facilitator.id, session_topic_1, "video")
     Map.get(console, String.to_atom(resource.type <> "Id"))
     |> is_nil |> assert
   end

   test "when pinboard enable then cen't add resource", %{facilitator: facilitator, session_topic_1: session_topic_1, resource: resource} do
     {:ok, _} = ConsoleService.enable_pinboard(facilitator.id, session_topic_1)
     {:error, error_message} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
     assert(ConsoleService.error_messages.pinboard_is_enable == error_message)
   end
 end

  test "add mini_survey", %{facilitator: facilitator, session_topic_1: session_topic_1, mini_survey: mini_survey} do
    {:ok, console} = ConsoleService.set_mini_survey(facilitator.id, session_topic_1, mini_survey.id)
    mini_survey_id = Map.get(console, String.to_atom("miniSurvey" <> "Id"))
    assert(mini_survey_id == mini_survey.id)
    assert(%Console{} = console )
  end

  test "remove mini_survey ", %{facilitator: facilitator, session_topic_1: session_topic_1, mini_survey: mini_survey} do
    {:ok, _} = ConsoleService.set_mini_survey(facilitator.id, session_topic_1, mini_survey.id)
    {:ok, console} = ConsoleService.remove(facilitator.id, session_topic_1, "miniSurvey")
    Map.get(console, String.to_atom("miniSurvey" <> "Id"))
    |> is_nil |> assert
  end

  describe "get_field_from_type# " do
    test "#video" do
      type = "video"
      field = ConsoleService.get_field_from_type(type)
      assert(field == :videoId)
    end

    test "#youtube link" do
      type = "link"
      field = ConsoleService.get_field_from_type(type)
      assert(field == :videoId)
    end
  end
end
