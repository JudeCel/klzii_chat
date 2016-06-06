defmodule KlziiChat.AuthControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}

  setup %{conn: conn, facilitator: facilitator} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    conn = put_req_header(conn, "authorization", jwt) |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "get auth token", %{conn: conn, facilitator: facilitator} do
    conn = get(conn, "/api/auth/token")
    assert(json_response(conn, 200))
    current_resource = Guardian.Plug.current_resource(conn)
    member = current_resource.session_member
    assert(member.id == facilitator.id)
  end
end
