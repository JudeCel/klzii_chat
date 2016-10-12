defmodule KlziiChat.DatabaseMonitoring.EventParserTest do
  use ExUnit.Case, async: true
  alias KlziiChat.DatabaseMonitoring.{EventParser}

  @id 3
  @payloade "{\"table\" : \"SessionTopics\", \"id\" : #{@id}, \"type\" : \"UPDATE\"}"

  describe "succses"  do
    test "processe_event" do
      assert({:ok, "Running in Test ENV"} = EventParser.processe_event("table_update",@payloade))
    end

    test "decode_message" do
      assert(%{"id" => @id} = EventParser.decode_message("table_update", @payloade))
    end

    test "when event select_job" do
      assert({:ok, EventParser, :session_topics, [@id]} = EventParser.select_job(%{"table" =>  "SessionTopics", "id" =>  @id}))
    end

    test "when unhandle event select_job" do
      message = EventParser.messages.errors.unhandle_event
      assert({:error, ^message} = EventParser.select_job(%{}))
    end
  end
end
