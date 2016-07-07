defmodule KlziiChat.PinboardResourceControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}
  alias KlziiChat.{Repo}
  @image "test/fixtures/images/hamster.jpg"

  setup %{conn: conn, participant: participant} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(participant)
    conn = put_req_header(conn, "authorization", jwt)

    {:ok,
      conn: put_req_header(conn, "accept", "application/json")
    }
  end

  test "upload image", %{conn: conn, session_topic_1: session_topic_1} do
    Ecto.build_assoc(
      session_topic_1, :console,
      pinboard: true
    ) |> Repo.insert!

    file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
    resp = post(conn, "api/pinboard_resource/upload", %{sessionTopicId: session_topic_1.id, name: "hamster", type: "image", scope: "collage", file: file })
      |> json_response(200)
    assert(%{"status" => "ok"} = resp)
  end
end
