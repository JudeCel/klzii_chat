defmodule KlziiChat.Services.PinboardResourceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{PinboardResourceService}

  def build_pinboard_console(session_topic_1, enable) do
      Ecto.build_assoc(
        session_topic_1, :console,
        pinboard: enable
      ) |> Repo.insert
  end

  setup %{account_user_account_manager: account_user} do

     resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "test image 1",
      type: "image",
      scope: "collage"
    ) |> Repo.insert!

    {:ok, resource: resource}
  end

  describe "succsess" do
    test "can add resource", %{participant: participant, session_topic_1: session_topic_1, resource: resource} do
      {:ok, _} = build_pinboard_console(session_topic_1, true)
      {:ok, pinboard_resource} = PinboardResourceService.add(participant.id, session_topic_1.id, resource.id)
      assert(pinboard_resource.resourceId == resource.id)
    end

    test "can replaice", %{account_user_account_manager: account_user, participant: participant, session_topic_1: session_topic_1, resource: resource} do
      resource2 = Ecto.build_assoc(
       account_user.account, :resources,
       accountUserId: account_user.id,
       name: "test image 2",
       type: "image",
       scope: "collage"
     ) |> Repo.insert!

      {:ok, _} = build_pinboard_console(session_topic_1, true)
      {:ok, pinboard_resource1} = PinboardResourceService.add(participant.id, session_topic_1.id, resource.id)
      {:ok, pinboard_resource2} = PinboardResourceService.add(participant.id, session_topic_1.id, resource2.id)
      assert(pinboard_resource1.id == pinboard_resource2.id)
      assert(pinboard_resource2.resourceId == resource2.id)
    end

    test "can remove", %{participant: participant, session_topic_1: session_topic_1, resource: resource} do
      {:ok, _} = build_pinboard_console(session_topic_1, true)
      {:ok, pinboard_resource1} = PinboardResourceService.add(participant.id, session_topic_1.id, resource.id)
      {:ok, pinboard_resource2} = PinboardResourceService.delete(participant.id, pinboard_resource1.id)
      assert(pinboard_resource1.id == pinboard_resource2.id)
      assert(pinboard_resource2.resourceId == nil)
    end
  end

  describe "failure" do
    test "can add resource", %{participant: participant, session_topic_1: session_topic_1, resource: resource} do
      {:error, _} = PinboardResourceService.add(participant.id, session_topic_1.id, resource.id)
    end
  end
end
