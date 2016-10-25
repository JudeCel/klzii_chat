defmodule KlziiChat.Services.Reports.Types.MessagesStarOnly do
  @behaviour KlziiChat.Services.Reports.Types.Behavior
  import KlziiChat.Services.Reports.Types.Messages

  def preload_messages_query(report) do
    exclude_facilitator = get_in(report.scopes, ["exclude", "role", "facilitator"]) || false
    KlziiChat.Queries.Messages.session_topic_messages(report.sessionTopicId, [ star: true, facilitator: exclude_facilitator ])
  end
end
