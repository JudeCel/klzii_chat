defmodule KlziiChat.Files.IdefntegrationTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.{Repo, Resource}
  alias KlziiChat.Files.Tasks, as: FileZipTask

  setup %{account_user_account_manager: account_user} do
    image = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool image",
      type: "image",
      scope: "collage"
    ) |> Repo.insert!

    zip = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool",
      type: "file",
      scope: "zip",
      status: "progress"
    ) |> Repo.insert!

    {:ok, zip: zip, image: image}
  end

  test "full flow test", %{zip: zip, image: image} do
     {:ok, resource} = FileZipTask.run(zip, [image.id])
     assert(resource.status == "completed")
     refute(resource.file |> is_nil)
  end

  test "full flow test with error", %{zip: zip} do
     FileZipTask.run(zip, [] )
     resource = Repo.get!(Resource, zip.id)
     assert(resource.status == "failed")
     assert(resource.properties == %{"error" => "Ids list can't be empty!"})
     assert(resource.file |> is_nil)
  end
end
