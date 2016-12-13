defmodule KlziiChat.Dashboard.SessionsBuilderChannel do
  use KlziiChat.Web, :channel
  alias KlziiChat.{Repo}
  import Ecto.Query, only: [from: 2]

  def join("sessionsBuilder:" <> session_id, _, socket) do
    if authorized?(socket, session_id) do
      {session_id, _} = Integer.parse(session_id)
        send(self, :after_join)
        {:ok, assign(socket, :session_id, session_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end

  end

  def handle_info(:after_join, socket) do
    {:noreply, socket}
  end

  def authorized?(socket, session_id) do
    account_id = Map.get(socket.assigns.account_user, :AccountId)

    from(sm in KlziiChat.Session, where:
      [ id: ^session_id,
        accountId: ^account_id
      ]
    )
    |> Repo.one
    |> case  do
        nil -> false
        _ -> can_accses?(socket.assigns.account_user)
       end
  end
  def can_accses?(%{role: role }) when role in ["accountManager", "facilitator", "admin"], do: true
  def can_accses?(_), do: false

end
