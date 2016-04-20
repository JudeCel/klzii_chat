defmodule KlziiChat.ResourcesControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}
  alias KlziiChat.{Repo}

  setup %{conn: conn, account_user: account_user} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(account_user)
    conn = put_req_header(conn, "authorization", jwt)

    resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool",
      type: "file",
      scope: "zip"
    ) |> Repo.insert!
    {:ok,
      conn: put_req_header(conn, "accept", "application/json"),
      resource: resource
    }
  end

  test "when not authorized header then return 401 and error unauthorized", %{conn: conn} do
    conn = delete_req_header(conn, "authorization")
    conn = get conn, resources_path(conn, :ping)
    assert json_response(conn, 401)["error"] == "unauthorized"
  end

  test "when authorized header then return 200 and status ok", %{conn: conn} do
    conn = get conn, resources_path(conn, :ping)
    assert json_response(conn, 200)["status"] == "ok"
  end

  test "return root key resources", %{conn: conn} do
    conn = get conn, resources_path(conn, :index, "all")
    assert json_response(conn, 200)["resources"] |> is_list
  end

  test "init zip action", %{conn: conn} do
    conn = post conn, resources_path(conn, :zip, %{"ids" => [1,2,3], "name"=> "newZpi"})
    assert json_response(conn, 200)["resource"]["name"] == "newZpi"
  end

  test "show", %{conn: conn, resource: resource} do
    conn = get conn, resources_path(conn, :show, resource.id)
    assert json_response(conn, 200)["resource"]["name"] == resource.name
  end

  test "delete", %{conn: conn, resource: resource} do
    conn = delete conn, resources_path(conn, :delete, ids: [resource.id])
    assert json_response(conn, 200)["ids"] |> is_list
  end
end
