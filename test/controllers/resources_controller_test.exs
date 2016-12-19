defmodule KlziiChat.ResourcesControllerTest do
  use KlziiChat.{ConnCase, AccountsCase}
  alias KlziiChat.{Repo}
  @image "test/fixtures/images/hamster.jpg"
  @pdf "test/fixtures/file/test.pdf"

  describe "when no subscription for resource" do
    setup %{conn: conn, accountManager_free: account_user} do
      { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(account_user)
      conn = put_req_header(conn, "authorization", jwt)

      on_exit fn ->
        KlziiChat.FileTestHelper.clean_up_uploads_dir
      end

      {:ok,
        conn: put_req_header(conn, "accept", "application/json")
      }
    end

    test "upload image", %{conn: conn} do
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      conn = post(conn, "api/resources/upload", %{name: "hamster", type: "image", scope: "collage", file: file })
      assert json_response(conn, 403)
    end
  end

  describe("regular user") do
    setup %{conn: conn, accountManager_core: account_user} do
      { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(account_user)
      conn = put_req_header(conn, "authorization", jwt)

      zip_resource = Ecto.build_assoc(
        account_user.account, :resources,
        accountUserId: account_user.id,
        name: "cool",
        type: "file",
        scope: "zip"
      ) |> Repo.insert!

      image_resource = Ecto.build_assoc(
        account_user.account, :resources,
        accountUserId: account_user.id,
        name: "cool iamge1",
        type: "image",
        scope: "collage"
      ) |> Repo.insert!

      on_exit fn ->
        KlziiChat.FileTestHelper.clean_up_uploads_dir
      end

      {:ok,
        conn: put_req_header(conn, "accept", "application/json"),
        zip_resource: zip_resource,
        image_resource: image_resource
      }
    end

    test "when not authorized header then return 401 and error unauthorized", %{conn: conn} do
      conn = delete_req_header(conn, "authorization")
      conn = get conn, resources_path(conn, :ping)
      assert json_response(conn, 401)["error"] == "unauthorized"
    end

    test "when authorized header then return 200 and status ok", %{conn: conn} do
      conn = get conn, resources_path(conn, :ping)
      assert json_response(conn, 200)["status"] == "ok"
    end

    test "return root key resources", %{conn: conn} do
      conn = get conn, resources_path(conn, :index)
      assert json_response(conn, 200)["resources"] |> is_list
    end

    test "upload youtube link", %{conn: conn} do
      file = "http://youtu.be/0zM3nApSvMg"
      conn = post conn, resources_path(conn, :upload, name: "youtubeLink", type: "link", scope: "videoService", file: file)
      assert json_response(conn, 200)["resource"] |> Map.get("name") == "youtubeLink"
      assert json_response(conn, 200)["resource"] |> Map.get("scope") == "videoService"
      assert json_response(conn, 200)["resource"] |> Map.get("type") == "link"
      assert json_response(conn, 200)["resource"] |> Map.get("source") == "youtube"
      assert json_response(conn, 200)["resource"] |> Map.get("url") |> Map.get("full") == "0zM3nApSvMg"
    end

    test "upload vimeo link", %{conn: conn} do
      file = "https://vimeo.com/193358188"
      conn = post conn, resources_path(conn, :upload, name: "vimeoLink", type: "link", scope: "videoService", file: file)
      assert json_response(conn, 200)["resource"] |> Map.get("name") == "vimeoLink"
      assert json_response(conn, 200)["resource"] |> Map.get("scope") == "videoService"
      assert json_response(conn, 200)["resource"] |> Map.get("type") == "link"
      assert json_response(conn, 200)["resource"] |> Map.get("source") == "vimeo"
      assert json_response(conn, 200)["resource"] |> Map.get("url") |> Map.get("full") == "193358188"
    end

    test "upload image", %{conn: conn} do
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      conn = post(conn, "api/resources/upload", %{name: "hamster", type: "image", scope: "collage", file: file })
      assert json_response(conn, 200)["resource"]["name"] == "hamster"
      assert json_response(conn, 200)["resource"]["stock"] == false
    end

    test "upload pdf", %{conn: conn} do
      file = %Plug.Upload{ content_type:  Plug.MIME.path("test.pdf"), path: @pdf, filename: "test.pdf"}
      conn = post(conn, "api/resources/upload", %{name: "cool pdf", type: "file", scope: "collage", file: file })
      assert json_response(conn, 200)["resource"]["name"] == "cool pdf"
    end

    test "can't upload stock image skipe stock parametr", %{conn: conn} do
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      conn = post(conn, "api/resources/upload", %{stock: true, name: "hamster", type: "image", scope: "collage", file: file })
      assert json_response(conn, 200)["resource"]["name"] == "hamster"
      assert json_response(conn, 200)["resource"]["stock"] == false
    end

    test "init zip action", %{conn: conn, zip_resource: zip_resource, image_resource: image_resource} do
      Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      post(conn, "api/resources/upload", %{name: "hamster", type: "image", scope: "collage", file: file })

      conn = post conn, resources_path(conn, :zip, %{"ids" => [zip_resource.id,image_resource.id], "name"=> "newZpi"})
      assert json_response(conn, 200)["resource"]["name"] == "newZpi"
    end

    test "show", %{conn: conn, zip_resource: zip_resource} do
      conn = get conn, resources_path(conn, :show, zip_resource.id)
      assert json_response(conn, 200)["resource"]["name"] == zip_resource.name
    end

    test "closed session delete check", %{conn: conn, image_resource: image_resource} do
      conn = get conn, resources_path(conn, :closed_session_delete_check, ids: [image_resource.id])
      assert json_response(conn, 200)["used_in_closed_session"]["items"] |> is_list
    end

    test "delete", %{conn: conn, image_resource: image_resource} do
      conn = delete conn, resources_path(conn, :delete, ids: [image_resource.id])
      assert json_response(conn, 200)["not_removed_stock"]["items"] |> is_list
      assert json_response(conn, 200)["not_removed_used"]["items"] |> is_list
      assert json_response(conn, 200)["removed"]["items"] |> is_list
    end

    test "delete with resource", %{conn: conn} do
      file = %Plug.Upload{ content_type: Plug.MIME.path("hamster.jpg"), path: @image, filename: "hamster.jpg"}
      resp = post(conn, "api/resources/upload", %{name: "image_test_hamster", type: "image", scope: "collage", file: file })
       |> json_response(200)

      id = resp["resource"]["id"]
      conn = delete conn, resources_path(conn, :delete, ids: [id])
      assert json_response(conn, 200)["not_removed_stock"]["items"] |> is_list
      assert json_response(conn, 200)["not_removed_used"]["items"] |> is_list
      assert json_response(conn, 200)["removed"]["items"] |> is_list
    end

    test "wrong type", %{conn: conn} do
      file = %Plug.Upload{ content_type: Plug.MIME.path("test.mp3"), path: @image, filename: "test.mp3"}
      conn = post(conn, "api/resources/upload", %{name: "test_audio", type: "image", scope: "collage", file: file })
      assert json_response(conn, 415)
    end

    test "return stock images", %{conn: conn, admin: account_user_admin} do

      Ecto.build_assoc(
        account_user_admin.account, :resources,
        accountUserId: account_user_admin.id,
        stock: true,
        name: "cool iamge2",
        type: "image",
        scope: "collage"
      ) |> Repo.insert!

      conn = get(conn, "api/resources", %{stock: true, type: "image" })
      assert json_response(conn, 200)["resources"] |> length == 2
    end
  end

  describe("admin user") do
    setup %{conn: conn, admin: account_user_admin} do
      { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(account_user_admin)
      conn = put_req_header(conn, "authorization", jwt)
        |> put_req_header("accept", "application/json")
      on_exit fn ->
        KlziiChat.FileTestHelper.clean_up_uploads_dir
      end
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "upload stock image", %{conn: conn} do
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      resp_conn = post(conn, "api/resources/upload", %{stock: true,  name: "hamster", type: "image", scope: "collage", file: file })
      assert json_response(resp_conn, 200)["resource"]["name"] == "hamster"
      assert json_response(resp_conn, 200)["resource"]["stock"] == true
    end

    test "regular image upload", %{conn: conn} do
      file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
      resp_conn = post(conn, "api/resources/upload", %{name: "hamster", type: "image", scope: "collage", file: file })
      assert json_response(resp_conn, 200)["resource"]["name"] == "hamster"
      assert json_response(resp_conn, 200)["resource"]["stock"] == false
    end
  end
end
