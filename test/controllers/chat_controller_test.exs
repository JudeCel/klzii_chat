defmodule KlziiChat.ChatControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}, async: true

  setup %{conn: conn, facilitator: facilitator} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    {:ok, conn: conn, token: jwt,}
  end

  test "when use dev token", %{conn: conn, facilitator: facilitator} do
    conn = get(conn, "/", token_dev: facilitator.token)
    assert(html_response(conn, 200))
  end

  test "when in dev or test en", %{conn: conn, token: token} do
    conn = get(conn, "/", token: token)
    assert(html_response(conn, 200))
  end
end
