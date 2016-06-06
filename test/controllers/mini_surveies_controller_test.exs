defmodule KlziiChat.MiniSurveiesControllerTsest do
  use KlziiChat.{ConnCase, SessionMemberCase}

  setup %{conn: conn, facilitator: facilitator} do
    { :ok, jwt, _encoded_claims } =  Guardian.encode_and_sign(facilitator)
    conn = put_req_header(conn, "authorization", jwt) |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "#MiniSurveiesController get mini surveies for session", %{conn: conn, session_topic_1: session_topic_1} do
    conn = get(conn, "/api/mini_surveies/", %{"sessionTopicId" => session_topic_1.id})
    assert(json_response(conn, 200))
  end

  test "#MiniSurveiesController create mini surveies for session", %{conn: conn, session_topic_1: session_topic_1} do
    params = %{"sessionTopicId" => session_topic_1.id, "type" => "yesNoMaybe", "question" => "cool question", "title" => "cool title"}
    post(conn, "/api/mini_surveies/", params) |> json_response(200) |> assert
  end

  test "#MiniSurveiesController answer to qestion", %{conn: conn, session_topic_1: session_topic_1} do
    params = %{"sessionTopicId" => session_topic_1.id, "type" => "yesNoMaybe", "question" => "cool question", "title" => "cool title"}
    resp_survey = post(conn, "/api/mini_surveies/", params) |> json_response(200)

    answer_params = %{"answer" => %{"type" => "yesNoMaybe", "value" => "yes"} }
    conn = post(conn, "/api/mini_surveies/#{resp_survey["id"]}/answer/", answer_params)
      assert(json_response(conn, 200))
  end
end
