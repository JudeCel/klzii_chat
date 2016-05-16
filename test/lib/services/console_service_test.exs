defmodule KlziiChat.Services.ConsoleServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.ConsoleService
  alias KlziiChat.Console

  setup %{topic_1: topic_1, session: session, member: member, account_user: account_user} do

    {:ok, resource} = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert

    {:ok, session_id: session.id, member: member, resource: resource, topic_id: topic_1.id}
  end

  test "get console", %{session_id: session_id, topic_id: topic_id} do
    {:ok, first_console} = ConsoleService.get(session_id, topic_id)
    {:ok, same_console} = ConsoleService.get(session_id, topic_id)
    assert(first_console === same_console )
    assert(%Console{} = same_console )
  end

  test "add resource", %{member: member, topic_id: topic_id, resource: resource} do
    {:ok, console} = ConsoleService.set_resource(member.id, topic_id, resource.id)
    image_id = Map.get(console, String.to_atom(resource.type <> "Id"))
    assert(image_id == resource.id)
    assert(%Console{} = console )
  end

  test "remove resource", %{member: member, topic_id: topic_id, resource: resource} do
    {:ok, _} = ConsoleService.set_resource(member.id, topic_id, resource.id)
    {:ok, console} = ConsoleService.remove_resource(member.id, topic_id, "image")
    Map.get(console, String.to_atom(resource.type <> "Id"))
    |> is_nil |> assert
  end
end
