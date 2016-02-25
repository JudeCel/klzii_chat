defmodule KlziiChat.Services.TopicsService do
  alias KlziiChat.{Repo, Topic, EventView}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def history(topic_id, tag) do
    topic = Repo.get!(Topic, topic_id)
    events = Repo.all(
      from e in assoc(topic, :events),
        where: [tag: ^tag],
        where: is_nil(e.replyId),
        order_by: [desc: e.createdAt],
        limit: 200,
      preload: [:session_member, :votes, replies: [:replies, :session_member, :votes] ]
    )
    {:ok, Phoenix.View.render_many(events, EventView, "events.json")}
  end
end
