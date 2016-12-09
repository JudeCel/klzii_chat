defmodule KlziiChat.DatabaseMonitoring.EventParserTest do
  use ExUnit.Case, async: true
  alias KlziiChat.DatabaseMonitoring.{EventParser}

  @id 3
  @session_id 3
  @payloade "{\"table\" : \"SessionTopics\", \"id\" : #{@id}, \"session_id\" : #{@session_id}, \"type\" : \"UPDATE\"}"

  describe "succses"  do
    test "processe_event" do
      assert({:ok, "Running in Test ENV"} = EventParser.processe_event("table_update", @payloade))
    end

    test "decode_message" do
      assert(%{"id" => @id} = EventParser.decode_message("table_update", @payloade))
    end

    test "when event select_job" do
      map = %{"table" =>  "SessionTopics", "id" =>  @session_id, "session_id" => @session_id}
      assert({:ok, EventParser, :session_topics, [@session_id]} = EventParser.select_job(map))
    end

    test "when unhandle event select_job" do
      message = EventParser.messages.errors.unhandle_event
      assert({:error, ^message} = EventParser.select_job(%{}))
    end
  end
end
