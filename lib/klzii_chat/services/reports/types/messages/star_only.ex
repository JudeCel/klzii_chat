defmodule KlziiChat.Services.Reports.Types.Messages.StarOnly do
  import KlziiChat.Services.Reports.Types.Messages.Base, only: [
    get_session: 1,
    get_header_title: 1,
    get_session_topics: 1
  ]

  @spec default_fields() :: List.t[String.t]
  def default_fields() do
    ["First Name", "Comment", "Date", "Is Reply"]
  end

  def preload_messages_query(report) do
    exclude_facilitator = get_in(report.includes, ["facilitator"]) || false
    KlziiChat.Queries.Messages.session_topic_messages(report.sessionTopicId, [ star: true, facilitator: exclude_facilitator ])
  end
end
