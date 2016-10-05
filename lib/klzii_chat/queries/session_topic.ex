defmodule KlziiChat.Queries.SessionTopic do
  alias KlziiChat.{Session, SessionTopic, Account}
  import Ecto.Query, only: [from: 2]

  @spec find(Integer) :: Ecto.Query.t
  def find(session_topic_id) do
    from(s in SessionTopic,
      where: s.id == ^session_topic_id,
      preload: [session: [:brand_logo, :account, :brand_project_preference]]
    )
  end
end
