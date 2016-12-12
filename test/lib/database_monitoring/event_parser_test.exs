defmodule KlziiChat.DatabaseMonitoring.EventParserTest do
  use ExUnit.Case, async: true
  alias KlziiChat.DatabaseMonitoring.{EventParser}

  @id 3
  @session_id 3
  @payloade "{\"table\" : \"SessionTopics\", \"data\" : {\"id\": #{@id}, \"name\": \"Cool Session Topic1\", \"sessionId\":  #{@session_id} }, \"type\" : \"DELETE\"}"

  @unhandle_event EventParser.messages.errors.unhandle_event
  describe "succses"  do
    test "processe_event" do
      assert({:ok, "Running in Test ENV"} = EventParser.processe_event("table_update", @payloade))
    end

    test "decode_message" do
      assert(%{"data" => %{"id" => @id}} = EventParser.decode_message("table_update", @payloade))
    end

    test "when event select_job for SessionTopics" do
      map = %{"table" =>  "SessionTopics", "data" =>  %{"id" => @id, "sessionId" => @session_id }, "type" => "DELETE"}
      assert({:ok, :session_topics, [@session_id]} = EventParser.select_job(map))
    end

    test "when event select_job  for Invites" do
      invite_id = 2
      session_id = 4
      type =  "INSERT"
      map = %{"table" =>  "Invites", "data" =>  %{"id" => invite_id, "sessionId" => session_id}, "type" => type}
      assert({:ok, :invites, [^invite_id, ^session_id, ^type]} = EventParser.select_job(map))
    end

    test "when unhandle event select_job" do
      assert({:error, @unhandle_event} = EventParser.select_job(%{}))
    end
  end
end
