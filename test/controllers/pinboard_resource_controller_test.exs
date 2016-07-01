defmodule KlziiChat.PinboardResourceControllerTest do
  use KlziiChat.{ConnCase, SessionMemberCase}
  alias KlziiChat.Services.{PinboardResourceService}
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

  test "index", %{conn: conn, session_topic_1: session_topic_1} do
    resp = get(conn, "api/pinboard_resource/", %{"sessionTopicId" => session_topic_1.id})
      |> json_response(200)
    assert(%{"status" => "ok", "list" => []} == resp)
  end

  # test "upload image", %{conn: conn} do
  #   file = %Plug.Upload{ content_type: "image/jpg", path: @image, filename: "hamster.jpg"}
  #   %{"status" => status} = post(conn, "api/session_resources/upload", %{private: false,  name: "hamster", type: "image", scope: "collage", file: file })
  #     |> json_response(200)
  #   assert(status == "ok")
  # end

  # test "delete", %{conn: conn, image_resource: image_resource, facilitator: facilitator} do
  #   {:ok, session_resources} = SessionResourcesService.add_session_resources(image_resource.id, facilitator.id)
  #   session_resource = List.first(session_resources) |> Repo.preload([:resource])
  #   %{"id" => id, "type" => type} = delete(conn, session_resources_path(conn, :delete, session_resource.id))
  #     |> json_response(200)
  #
  #   assert(id == session_resource.id)
  #   assert(type == session_resource.resource.type)
  # end
end
