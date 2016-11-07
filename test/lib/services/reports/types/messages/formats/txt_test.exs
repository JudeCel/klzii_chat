defmodule KlziiChat.Services.Reports.Types.Messages.Formats.TxtTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Messages
  alias KlziiChat.Services.{SessionReportingService, MessageService}

  setup %{session_topic_1: session_topic, facilitator: facilitator, participant: participant, contact_list: contact_list} do
    {:ok, message } = MessageService.create_message(participant, session_topic.id, %{"emotion" => 1, "body" => "!!!!1"})
    {:ok, message1 } = MessageService.create_message(facilitator, session_topic.id, %{"replyId" => message.id, "emotion" => 2, "body" => "!!!!2"})
    {:ok, message2 } = MessageService.create_message(facilitator, session_topic.id, %{"replyId" => message1.id, "emotion" => 2, "body" => "!!!!3"})
    {:ok, _ } = MessageService.create_message(participant, session_topic.id, %{"emotion" => 2, "body" => "!!!!5"})


    topic_report_payload =  %{"sessionTopicId" => session_topic.id, "format" => "txt",
      "type" => "messages",
      "includeFields" => Enum.concat(["city", "state"], Enum.take(contact_list.customFields, 2))
    }

    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, topic_report_payload)
    {:ok, topic_report_data} = Messages.Base.get_data(topic_report)

    session_report_payload =  %{"format" => "txt", "type" => "messages" }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, session_report_payload)

    {:ok, session_report_data} = Messages.Base.get_data(session_report)
    {:ok, topic_report_data: topic_report_data, session_report_data: session_report_data}
  end

  describe "processe_data" do
    test "topic report", %{topic_report_data: topic_report_data} do
      assert({:ok, _} = Messages.Formats.Txt.processe_data(topic_report_data))
    end

    test "session report", %{session_report_data: session_report_data} do
      assert({:ok, stream} = Messages.Formats.Txt.processe_data(session_report_data))
      [ _ | data ] =  Enum.to_list(stream)
      assert(length(data) == 1)
    end
  end

  describe "set date in data accumulator" do
    setup %{topic_report_data: data} do
      fields = get_in(data, ["fields"])
      {:ok, result} = Messages.Formats.Txt.render_string(data)
      {:ok, result: result, fields: fields}
    end

    test "should be list with 4 elements", %{result: result} do
      data = Agent.get(result.data, &(&1))
      assert(Enum.count(data) == 4)
    end

    test "one element contains same all elements from fields lis", %{result: result, fields: fields} do
      data = Agent.get(result.data, &(&1)) |> List.first
      row = String.split(data, ",")
      assert(length(fields) == length(row))
    end
  end
end
