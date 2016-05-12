defmodule KlziiChat.SessionResourcesControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}
  alias KlziiChat.Services.{SessionResourcesService}
  alias KlziiChat.{Repo}
  @image "test/fixtures/images/hamster.jpg"

  setup %{conn: conn, member: member, account_user: account_user} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(member)
    conn = put_req_header(conn, "authorization", jwt)

    image_resource = Ecto.build_assoc(
      account_user.account, :resources,
      accountUserId: account_user.id,
      name: "cool iamge",
      type: "image",
      scope: "collage"
    ) |> Repo.insert!

    {:ok,
      conn: put_req_header(conn, "accept", "application/json"),
      image_resource: image_resource,
      member: member
    }
  end

  test "upload youtube link", %{conn: conn} do
    file = "http://youtu.be/0zM3nApSvMg"
    conn = post conn, session_resources_path(conn, :upload, private: false, name: "youtubeLink", type: "link", scope: "youtube", file: file)
    assert json_response(conn, 200)["status"] == "ok"
  end

  test "upload image", %{conn: conn} do
    file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
    conn = post(conn, "api/session_resources/upload", %{private: false,  name: "hamster", type: "image", scope: "collage", file: file })
    assert json_response(conn, 200)["status"] == "ok"
  end

  test "delete", %{conn: conn, image_resource: image_resource, member: member} do
    {:ok, resurces} = SessionResourcesService.add_session_resources([image_resource.id], member.id)
    resurce = List.first(resurces)
    conn = delete conn, session_resources_path(conn, :delete, resurce.id)
    assert json_response(conn, 200)["status"] == "ok"
  end
end
