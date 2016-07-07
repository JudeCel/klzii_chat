defmodule KlziiChat.SessionResourcesControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}
  alias KlziiChat.Services.{SessionResourcesService}
  alias KlziiChat.{Repo}
  @image "test/fixtures/images/hamster.jpg"

  setup %{conn: conn, facilitator: facilitator, account_user_account_manager: account_user} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
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
      image_resource: image_resource
    }
  end

  test "upload youtube link", %{conn: conn} do
    file = "http://youtu.be/0zM3nApSvMg"
    %{"status" => status} = post(conn, session_resources_path(conn, :upload, private: false, name: "youtubeLink", type: "link", scope: "youtube", file: file))
      |> json_response(200)
    assert(status == "ok")
  end

  test "upload image", %{conn: conn} do
    file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
    %{"status" => status} = post(conn, "api/session_resources/upload", %{private: false,  name: "hamster", type: "image", scope: "collage", file: file })
      |> json_response(200)
    assert(status == "ok")
  end

  test "delete", %{conn: conn, image_resource: image_resource, facilitator: facilitator} do
    {:ok, session_resources} = SessionResourcesService.add_session_resources(image_resource.id, facilitator.id)
    session_resource = List.first(session_resources) |> Repo.preload([:resource])
    %{"id" => id, "type" => type} = delete(conn, session_resources_path(conn, :delete, session_resource.id))
      |> json_response(200)

    assert(id == session_resource.id)
    assert(type == session_resource.resource.type)
  end

  describe("wrong media type") do
    test "upload image", %{conn: conn} do
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      %{"errors" => _} = post(conn, "api/session_resources/upload", %{name: "hamster", type: "video", scope: "collage", file: file })
        |> json_response(200)
    end
  end
end
