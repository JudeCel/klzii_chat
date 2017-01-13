defmodule KlziiChat.Services.MailgunService do
  alias KlziiChat.{Repo, Invite}
  use Timex

  @spec mailgun_webhooks(Map.t) :: {:ok, Map.t} | {:error, String.t}
  def mailgun_webhooks(params) do
    with  {:ok, update_params} <- detect_event(params),
          {:ok, message_id} <- get_messasge_id(params),
          {:ok, _} <- update_invite(update_params, message_id),
    do: {:ok, update_params}
  end

  def update_invite(attrs, message_id) do
    case Repo.get_by(Invite, mailMessageId:  message_id) do
      nil ->
        {:ok, "not found"}
      invite ->
        Invite.changeset(invite, attrs)
        |> Repo.update
    end
  end

  def get_messasge_id(%{"Message-Id" => message_id}) do
    id = Regex.replace(~r/[<>]/, message_id, "")
    {:ok, id}
  end
  def get_messasge_id(_) do
    {:error, "No key Message-Id"}
  end

  def detect_event(%{"event" => "dropped"} = params) do
    resp = %{
      webhookMessage: Map.get(params, "description"),
      webhookEvent: Map.get(params, "event"),
      webhookTime: Timex.now,
      emailStatus: "failed"
    }
    {:ok, resp}
  end
  def detect_event(%{"event" => "delivered"} = params) do
    resp = %{
      webhookMessage: "delivered",
      webhookEvent: Map.get(params, "event"),
      webhookTime: Timex.now,
      emailStatus: "sent"
    }
    {:ok, resp}
  end
  def detect_event(%{"event" => "bounced"} = params) do
    resp = %{
      webhookMessage: Map.get(params, "error"),
      webhookEvent: Map.get(params, "event"),
      webhookTime: Timex.now,
      emailStatus: "failed"
    }
    {:ok, resp}
  end

  def detect_event(params) do
    IO.inspect params
    {:error, "event not found"}
  end
end
