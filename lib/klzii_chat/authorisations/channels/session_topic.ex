defmodule KlziiChat.Authorisations.Channels.SessionTopic do
  alias KlziiChat.{Repo, SessionMember}
  import Ecto.Query, only: [from: 2]

  def authorized?(socket, sesssion_topic_id) do
    session_memeber_id = socket.assigns.session_member.id
    query(session_memeber_id, sesssion_topic_id)
    |> valid?
  end

  defp query(session_memeber_id, sesssion_topic_id) do
    from(sm in SessionMember,
     join: s in assoc(sm, :session),
     join: st in assoc(s, :session_topics),
     where: sm.id == ^session_memeber_id,
     where: st.id == ^sesssion_topic_id,
     select: count(sm.id, :distinct)
   ) |> Repo.one
  end

  defp valid?(result) do
    result > 0
  end
end
