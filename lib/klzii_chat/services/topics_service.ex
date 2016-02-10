defmodule KlziiChat.Services.TopicsService do
  alias KlziiChat.{Repo, Topic, EventView}
  import Ecto
  import Ecto.Query, only: [from: 1, from: 2]

  def history(topic_id, tag) do
    topic = Repo.get!(Topic, topic_id)
    events = Repo.all(
      from e in assoc(topic, :events),
        where: [tag: ^tag],
        order_by: [desc: e.createdAt],
        limit: 200,
      preload: [:session_member]
    )
    {:ok, Phoenix.View.render_many(events, EventView, "events.json")}
  end
end
