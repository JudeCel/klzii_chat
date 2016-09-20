defmodule KlziiChat.Services.SessionTopicReportingServiceTest do
  use KlziiChat.{ModelCase, SessionMemberCase}
  alias KlziiChat.Services.{SessionTopicReportingService}
  alias KlziiChat.{Message}

  setup %{session: session, session_topic_1: session_topic_1, facilitator: facilitator, participant: participant} do
    {:ok, create_date1} = Ecto.DateTime.cast("2016-05-20T09:50:00Z")
    {:ok, create_date2} = Ecto.DateTime.cast("2016-05-20T09:55:00Z")

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: facilitator.id,
      body: "test message 1",
      emotion: 0,
      star: true,
      createdAt: create_date1,
      updatedAt: create_date1
    ) |> Repo.insert!()

    Ecto.build_assoc(
      session_topic_1, :messages,
      sessionTopicId: session_topic_1.id,
      sessionMemberId: participant.id,
      body: "test message 2",
      emotion: 1,
      star: false,
      createdAt: create_date2,
      updatedAt: create_date2
    ) |> Repo.insert!()

    on_exit fn ->
      KlziiChat.FileTestHelper.clean_up_uploads_dir
    end

    {:ok, session: session, session_topic: session_topic_1}
  end

    @spec preload_dependencies(%Message{} | [%Message{}] ) :: %Message{} | [%Message{}]
    defp preload_dependencies(message) do
      replies_query = from(st in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, :replies])
      {:ok, Repo.preload(message, [:session_member, :votes, replies: replies_query ])}
    end


  describe "#save_report" do
    test "text", %{session_topic: session_topic} do
      {:ok, _} = SessionTopicReportingService.save_report("some_name1", :txt, session_topic.id, false, false )
    end

    test "csv",  %{session_topic: session_topic} do
      {:ok, _} = SessionTopicReportingService.save_report("some_name2", :csv, session_topic.id, false, false )
    end

    test "pdf", %{session_topic: session_topic} do
      {:ok, _} = SessionTopicReportingService.save_report("some_name3", :pdf, session_topic.id, false, false )
    end

    test "error case",  %{session_topic: session_topic} do
      {:error, _} = SessionTopicReportingService.save_report("some_name4", :wrong, session_topic.id, false, false )
    end
  end

  describe "#get_report" do
    test "text", %{session_topic: session_topic} do
      {:ok, _} = SessionTopicReportingService.get_report(:txt, session_topic.id, false, false )
    end

    test "csv",  %{session_topic: session_topic} do
      {:ok, _} = SessionTopicReportingService.get_report(:csv, session_topic.id, false, false )
    end

    test "pdf", %{session_topic: session_topic} do
      {:ok, _} = SessionTopicReportingService.get_report(:pdf, session_topic.id, false, false )
    end

    test "error case",  %{session_topic: session_topic} do
      {:error, _} = SessionTopicReportingService.get_report(:wrong, session_topic.id, false, false )
    end
  end

  test "#csv_header" do
    header_content = ["Name", "Comment", "Date", "Is tagged", "Is reply", "Emotion"]
    header = SessionTopicReportingService.csv_header

    Enum.each(header_content, fn(item) ->
      assert(String.contains?(header, item))
     end)
  end

  test "#get_stream :txt", %{session_topic: session_topic} do
    session_name = "cool sesssion name jee"

    {:ok, messages} = KlziiChat.Queries.Messages.session_topic_messages(session_topic.id, [ star: false, facilitator: false ])
    |> Repo.all |> preload_dependencies

    text_string = SessionTopicReportingService.get_stream(:txt, messages, session_name, session_topic.name, session_topic.session.timeZone)
    |> Enum.to_list |> Enum.join

    assert(String.contains?(text_string, session_name))
    assert(String.contains?(text_string, session_topic.name))

    Enum.each(messages, fn(message) ->
      assert(String.contains?(text_string, message.body))
    end)
  end

  test "#get_stream :csv", %{session_topic: session_topic} do
    session_name = "cool sesssion name jee"

    {:ok, messages} = KlziiChat.Queries.Messages.session_topic_messages(session_topic.id, [ star: false, facilitator: false ])
    |> Repo.all |> preload_dependencies

    csv_string = SessionTopicReportingService.get_stream(:csv, messages, session_topic.name, session_name, session_topic.session.timeZone)
    |> Enum.to_list |> Enum.join

    assert(String.contains?(csv_string, SessionTopicReportingService.csv_header) )

    Enum.each(messages, fn(message) ->
      assert(String.contains?(csv_string, message.body))
    end)
  end

  test "#get_html", %{session_topic: session_topic} do
    account_name = "account name cool"
    session_name = "cool sesssion name jee"

    {:ok, messages} = KlziiChat.Queries.Messages.session_topic_messages(session_topic.id, [ star: false, facilitator: false ])
    |> Repo.all |> preload_dependencies

    html_string = SessionTopicReportingService.get_html(:html, messages, session_topic.name, session_name, account_name, session_topic.session.timeZone)

    assert(String.contains?(html_string, session_name))
    assert(String.contains?(html_string, account_name))
    assert(String.contains?(html_string, session_topic.name))

    Enum.each(messages, fn(message) ->
      assert(String.contains?(html_string, message.body))
    end)
  end
end
