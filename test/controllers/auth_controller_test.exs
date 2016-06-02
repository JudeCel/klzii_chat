defmodule KlziiChat.AuthControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}
  alias KlziiChat.Helpers.UrlHelper

  setup %{conn: conn, facilitator: facilitator} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    conn = put_req_header(conn, "authorization", jwt) |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "get auth token", %{conn: conn, facilitator: facilitator} do
    conn = get(conn, "/api/auth/token")
    assert(json_response(conn, 200)["redirect_url"] == UrlHelper.auth_redirect_url(facilitator.token))
  end
end
