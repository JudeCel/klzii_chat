defmodule KlziiChat.ChatControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}, async: true

  setup %{conn: conn, facilitator: facilitator} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    { :ok, conn: conn, token: jwt }
  end

  describe("Join") do
    test "when use dev token", %{conn: conn, facilitator: facilitator} do
      conn = get(conn, "/", token_dev: facilitator.token)
      assert(html_response(conn, 200))
    end

    test "when in dev or test env", %{conn: conn, token: token} do
      conn = get(conn, "/", token: token)
      assert(html_response(conn, 200))
    end

    test "when ghost user", %{conn: conn, participant_ghost: participant_ghost} do
      conn = get(conn, "/", ghost_token: participant_ghost.token)
      assert(html_response(conn, 200))
    end
  end
end
