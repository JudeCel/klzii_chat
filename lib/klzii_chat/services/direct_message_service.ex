defmodule KlziiChat.Services.DirectMessageService do
  alias KlziiChat.{Repo, Session}
  alias KlziiChat.Helpers.IntegerHelper
  import Ecto

  @spec create_message(Integer.t, Map.t) :: {:ok, Map.t} | {:error, Ecto.Changeset.t}
  def create_message(session_id, %{"senderId" => senderId, "recieverId" => recieverId, "text" => text}) do
    session = Repo.get!(Session, session_id)

    build_assoc(
      session, :direct_messages,
      senderId: IntegerHelper.get_num(senderId),
      recieverId: IntegerHelper.get_num(recieverId),
      text: text
    )
    |> Repo.insert
  end
end
