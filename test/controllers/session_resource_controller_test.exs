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

      on_exit fn ->
        KlziiChat.FileTestHelper.clean_up_uploads_dir
      end

      {:ok,
        conn: put_req_header(conn, "accept", "application/json"),
        image_resource: image_resource
      }
    end

    test "upload youtube link", %{conn: conn} do
      file = "http://youtu.be/0zM3nApSvMg"
      %{"status" => status} = post(conn, session_resources_path(conn, :upload, private: false, name: "youtubeLink", type: "link", scope: "videoService", file: file))
      |> json_response(200)
      assert(status == "ok")
    end

    test "upload vimeo link", %{conn: conn} do
      file = "https://vimeo.com/193358188"
      %{"status" => status} = post(conn, session_resources_path(conn, :upload, private: false, name: "vimeoLink", type: "link", scope: "videoService", file: file))
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

    test "can't delete if resource used in session", %{conn: conn, facilitator: facilitator} do
      file = %Plug.Upload{ content_type: Plug.MIME.path("hamster.jpg"), path: @image, filename: "hamster.jpg"}
      resp = post(conn, "api/resources/upload", %{name: "image_test_hamster", type: "image", scope: "collage", file: file })
       |> json_response(200)

      id = resp["resource"]["id"]
      {:ok, _} = SessionResourcesService.add_session_resources(id, facilitator.id)

      conn = delete conn, resources_path(conn, :delete, ids: [id])
      items = json_response(conn, 200)["not_removed_used"]["items"]
      
      assert json_response(conn, 200)
      assert(items == [%{"id" => id}])
    end

  describe("wrong media type") do
    test "upload image", %{conn: conn} do
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      %{"errors" => _} = post(conn, "api/session_resources/upload", %{name: "hamster", type: "video", scope: "collage", file: file })
      |> json_response(415)
    end
  end


  describe "can add stock image to session resource" do
    setup %{conn: conn, facilitator: facilitator, account_user_admin: account_user_admin} do
      { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
      conn = put_req_header(conn, "authorization", jwt)

      image_resource = Ecto.build_assoc(
      account_user_admin.account, :resources,
      accountUserId: account_user_admin.id,
      name: "cool iamge",
      type: "image",
      scope: "collage",
      stock: true
      ) |> Repo.insert!

      on_exit fn ->
        KlziiChat.FileTestHelper.clean_up_uploads_dir
      end

      {:ok,
        conn: put_req_header(conn, "accept", "application/json"),
        image_resource: image_resource
      }
    end

    test "create", %{conn: conn, image_resource: image_resource} do
      post(conn, session_resources_path(conn, :create, %{"ids" => [image_resource.id]}))
      |> json_response(200)
    end
  end
end
