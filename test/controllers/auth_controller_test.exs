defmodule KlziiChat.AuthControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}
  alias KlziiChat.{Repo}

  setup %{conn: conn, member: member} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(member)
    conn = put_req_header(conn, "authorization", jwt) |> put_req_header("accept", "application/json")
    {:ok, conn: conn, member: member}
  end

  test "get auth token", %{conn: conn, member: member} do
    conn = get(conn, "/api/auth/token")
    json_response(conn, 200)["redirect_url"]
      |> String.contains?(member.token)
      |> assert
  end
end
