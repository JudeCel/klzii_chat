defmodule KlziiChat.Services.Resourecs do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Queries.Resources, as: QueriesResources
  alias KlziiChat.{Repo, Resource}
  alias KlziiChat.Services.SessionResourcesService

  setup %{account_user: account_user, session: session, member: member} do
    Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool",
      type: "file",
      scope: "zip"
    ) |> Repo.insert!

    base_query = Ecto.Query.from(r in Resource)
    {:ok, base_query: base_query, account_user: account_user, session_id: session.id, member_id: member.id,}
  end

  test "when admin can see all resources", %{account_user: account_user} do
    count = QueriesResources.add_role_scope(account_user)
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

  test "find by params when both type and scope one not match", %{base_query: base_query} do
    count = QueriesResources.find_by_params(base_query, %{"scope" => ["pdf"], "type" => "file"}) |> Repo.all |> Enum.count
    assert(count == 0 )
  end

  test "find by params and exclude 1 of 3 session resources by sesion id (2 left)",
    %{account_user: account_user, member_id: member_id} do
      resource =
        Ecto.build_assoc(
          account_user.account, :resources,
          accountUserId: account_user.id,
          name: "cool 2",
          type: "file",
          scope: "zip"
        ) |> Repo.insert!

      Ecto.build_assoc(
        account_user.account, :resources,
        accountUserId: account_user.id,
        name: "cool 3",
        type: "file",
        scope: "zip"
      ) |> Repo.insert!

      %KlziiChat.AccountUser{:"AccountId" => accountId} = account_user

      {:ok, _} = SessionResourcesService.add_session_resources([resource.id], member_id)

      count =
        QueriesResources.add_role_scope(account_user)
        |> QueriesResources.find_by_params(%{})
        |> QueriesResources.exclude_by_session_id(accountId, member_id)
        |> Repo.all
        |> Enum.count

      assert(count == 2)
  end

end
