defmodule KlziiChat.ResourcesControllerTest do
  use KlziiChat.ConnCase
  use KlziiChat.SessionMemberCase

  setup %{conn: conn, account_user: account_user} do
    { :ok, jwt, encoded_claims } =  Guardian.encode_and_sign(account_user)
    conn = put_req_header(conn, "authorization", jwt)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
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
end
