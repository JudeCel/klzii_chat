defmodule KlziiChat.Reporting.PreviewController do
  alias KlziiChat.{Repo, SessionTopic, Message }
  use KlziiChat.Web, :controller

  def index(conn, %{"session_topic_id" => session_topic_id}) do
    session_topic = Repo.get!(SessionTopic, session_topic_id)

    session_topic = Repo.preload(session_topic, [session: [:account] ])

    {:ok, messages} = Repo.all(
      from e in assoc(session_topic, :messages),
        where: is_nil(e.replyId),
        order_by: [asc: e.createdAt],
        limit: 200
      ) |> preload_dependencies

      header_title = "Chat History - #{session_topic.session.account.name} / #{session_topic.session.name}"
      
      conn |>
      put_layout("report.html") |>
      render("messages.html", %{header_title: header_title, messages: messages, img_path: "/images/"})
  end

  @spec preload_dependencies(%Message{} | [%Message{}] ) :: %Message{} | [%Message{}]
  defp preload_dependencies(message) do
    replies_query = from(st in Message, order_by: [asc: :createdAt], preload: [:session_member, :votes, :replies])
    {:ok, Repo.preload(message, [:session_member, :votes, replies: replies_query ])}
  end
end
