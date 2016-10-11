defmodule KlziiChat.DatabaseMonitoring.Listener do
  use Boltun, otp_app: :klzii_chat

  listen do
    channel "table_update", :processe_event
  end


  @spec messages() :: Map.t
  def messages do
    %{
      errors: %{
        unhandle_event: "unhandle channel event"
      }
    }
  end

  @spec session_topics(Integer.t) :: {:ok, String.t} | {:error, String.t}
  def session_topics(id) do
    Exq.enqueue(Exq, "notify", KlziiChat.BackgroundTasks.SessionTopic, [id])
  end

  def processe_event(channel, payload) do
    case Mix.env do
      :test ->
        {:ok, "Running in Test ENV"}
      _ ->
        decode_message(channel, payload) |> create_job
    end
  end

  @spec decode_message(String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  def decode_message(_, payload) do
    Poison.decode!(payload)
  end

  @spec create_job(Map.t) :: {:ok, String.t} | {:error, String.t}
  def create_job(job_params) do
    case job_params do
      %{"table" =>  "SessionTopics", "id" =>  id} ->
        session_topics(id)
      _ ->
        {:error, messages.errors.unhandle_event}
    end
  end
end
