defmodule KlziiChat.Services.Reports.Types.Messages.Formats.CsvTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.Reports.Types.Messages
  alias KlziiChat.Services.SessionReportingService

  setup %{session_topic_1: session_topic, facilitator: facilitator, participant: participant, contact_list: contact_list} do
    Ecto.build_assoc(
      session_topic, :messages,
      sessionTopicId: session_topic.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 0,
      star: true,
      replyLevel: 0,
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic, :messages,
      sessionTopicId: session_topic.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 1,
      star: false,
      replyLevel: 0,
    ) |> Repo.insert!()

    topic_report_payload =  %{"sessionTopicId" => session_topic.id, "format" => "pdf",
      "type" => "messages",
      "customFildes" =>  Enum.take(contact_list.customFields, 4)
    }

    {:ok, topic_report} = SessionReportingService.create_report(facilitator.id, topic_report_payload)
    {:ok, topic_report_data} = Messages.Base.get_data(topic_report)

    session_report_payload =  %{"format" => "pdf", "type" => "messages" }
    {:ok, session_report} = SessionReportingService.create_report(facilitator.id, session_report_payload)

    {:ok, session_report_data} = Messages.Base.get_data(session_report)
    {:ok, topic_report_data: topic_report_data, session_report_data: session_report_data}
  end

  describe "processe_data" do
    test "topic report", %{topic_report_data: topic_report_data} do
      assert({:ok, _} =Messages.Formats.Csv.processe_data(topic_report_data))
    end

    test "session report", %{session_report_data: session_report_data} do
      assert({:ok, stream} = Messages.Formats.Csv.processe_data(session_report_data))
      [ _ | data ] =  Enum.to_list(stream)
      assert(length(data) == 1)
    end
  end

  describe "get_data" do
    setup %{topic_report_data: data} do
      session = get_in(data, ["session"])
      default_fields = get_in(data, ["default_fields"])
      [session_topic |_ ] = get_in(data, ["session_topics"])
      [message | _ ] = session_topic.messages
      result = Messages.Formats.Csv.get_data(message, session, default_fields)
      {:ok, result: result, default_fields: default_fields}
    end

    test "is map", %{result: result} do
      assert(%{} = result)
    end

    test "is all keys reqired", %{default_fields: default_fields, result: result} do
      keys = Map.keys(result)
      assert(length(default_fields) == length(keys))
    end
  end
end
