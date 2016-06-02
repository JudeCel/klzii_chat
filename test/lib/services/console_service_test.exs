defmodule KlziiChat.Services.ConsoleServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.ConsoleService
  alias KlziiChat.Console

  setup %{session_topic_1: session_topic_1, session: session, account_user: account_user} do

     resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert!

     youtube_resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "youtube test link ",
      type: "link",
      scope: "collage"
    ) |> Repo.insert!

    {:ok, session_id: session.id, youtube_resource: youtube_resource, resource: resource, session_topic_1: session_topic_1.id}
  end

  test "get console", %{session_id: session_id, session_topic_1: session_topic_1} do
    {:ok, first_console} = ConsoleService.get(session_id, session_topic_1)
    {:ok, same_console} = ConsoleService.get(session_id, session_topic_1)
    assert(first_console === same_console )
    assert(%Console{} = same_console )
  end

  test "add resource", %{facilitator: facilitator, session_topic_1: session_topic_1, resource: resource} do
    {:ok, console} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
    image_id = Map.get(console, String.to_atom(resource.type <> "Id"))
    assert(image_id == resource.id)
    assert(%Console{} = console )
  end

  test "remove resource ", %{facilitator: facilitator, session_topic_1: session_topic_1, resource: resource} do
    {:ok, _} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
    {:ok, console} = ConsoleService.remove_resource(facilitator.id, session_topic_1, "image")
    Map.get(console, String.to_atom(resource.type <> "Id"))
    |> is_nil |> assert
  end

  test "add resource #youtube", %{facilitator: facilitator, session_topic_1: session_topic_1, youtube_resource: resource} do
    {:ok, console} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
    video_id = Map.get(console, String.to_atom("videoId"))
    assert(video_id == resource.id)
    assert(%Console{} = console )
  end

  test "remove resource #youtube", %{facilitator: facilitator, session_topic_1: session_topic_1, youtube_resource: resource} do
    {:ok, _} = ConsoleService.set_resource(facilitator.id, session_topic_1, resource.id)
    {:ok, console} = ConsoleService.remove_resource(facilitator.id, session_topic_1, "video")
    Map.get(console, String.to_atom(resource.type <> "Id"))
    |> is_nil |> assert
  end

  test "get field from type #video" do
    type = "video"
    field = ConsoleService.get_field_from_type(type)
    assert(field == :videoId)
  end

  test "get field from type #youtube link" do
    type = "link"
    field = ConsoleService.get_field_from_type(type)
    assert(field == :videoId)
  end

  test "get field from type image" do
    type = "image"
    field = ConsoleService.get_field_from_type(type)
    assert(field == :imageId)
  end
end
