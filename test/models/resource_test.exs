defmodule KlziiChat.ResourceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}, async: true

  alias KlziiChat.Resource

  test "uniq resource name", %{account_user_account_manager: account_user} do
    resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool",
      type: "file",
      scope: "zip"
    ) |> Repo.insert!

    params = %{accountId: resource.accountId,
      name: resource.name,
      type: resource.type,
      scope: resource.scope,
      accountUserId: resource.accountUserId
     }
    {:error, changeset } = Resource.changeset(%Resource{}, Map.put(params, :name, resource.name)) |> Repo.insert
    {:name, "has already been taken"} in changeset.errors
  end
end
