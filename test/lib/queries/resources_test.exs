defmodule KlziiChat.Services.Resourecs do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.Resources, as: QueriesResources
  alias KlziiChat.{Repo, Resource, AccountUser}

  setup %{account_user: account_user} do
    Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool",
      type: "file",
      scope: "zip"
    ) |> Repo.insert!

    base_query = Ecto.Query.from(r in Resource)
    {:ok, base_query: base_query}
  end

  test "when admin can see all resources" do
    count = QueriesResources.add_role_scope(%AccountUser{role: "admin"})
      |> Repo.all |> Enum.count
    assert(count == 1 )
  end

  test "find by params when params is empty return all resources", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{}) |> Repo.all |> Enum.count
    assert(count == 1 )
  end

  test "find by params when in params type is file", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"type" => "file"}) |> Repo.all |> Enum.count
    assert(count == 1 )
  end

  test "find by params when in params type is file and in array", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"type" => ["file", "image"]}) |> Repo.all |> Enum.count
    assert(count == 1 )
  end

  test "find by params when in params type in array without any match", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"type" => ["audio", "image"]}) |> Repo.all |> Enum.count
    assert(count == 0 )
  end

  test "find by params when in params scope is zip", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"scope" => "zip"}) |> Repo.all |> Enum.count
    assert(count == 1 )
  end

  test "find by params when in params scope is zip and in a array", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"scope" => ["zip", "collage"]}) |> Repo.all |> Enum.count
    assert(count == 1 )
  end

  test "find by params when in params scope in array without any match", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"scope" => ["collage"]}) |> Repo.all |> Enum.count
    assert(count == 0 )
  end

  test "find by params when both type and scope", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"scope" => ["zip"], "type" => "file"}) |> Repo.all |> Enum.count
    assert(count == 1 )
  end

  test "find by params when both type and scope one not macth", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"scope" => ["pdf"], "type" => "file"}) |> Repo.all |> Enum.count
    assert(count == 0 )
  end
end
