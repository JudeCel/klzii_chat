defmodule KlziiChat.Authorisations.Channels.SessionTopic do
  alias KlziiChat.{Repo, SessionMember}
  import Ecto.Query, only: [from: 2]

  def authorized?(socket, sesssion_topic_id) do
    session_memeber_id = socket.assigns.session_member.id
    from(sm in SessionMember,
      join: s in assoc(sm, :session),
      join: st in assoc(s, :session_topics),
      where: sm.id == ^session_memeber_id,
      where: st.id == ^sesssion_topic_id
    ) |> Repo.one
      |> case  do
        %SessionMember{} ->
          true
        _ ->
        false
      end
  end
end
