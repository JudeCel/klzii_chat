defmodule KlziiChat.ChatControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}, async: true

  setup %{conn: conn, member: member} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(member)
    {:ok, conn: conn, token: jwt, member: member}
  end

  test "when use dev token", %{conn: conn, member: member} do
    conn = get(conn, "/", token_dev: member.token)
    assert(html_response(conn, 200))
  end

  test "when in dev or test en", %{conn: conn, token: token} do
    conn = get(conn, "/", token: token)
    assert(html_response(conn, 200))
  end
end
