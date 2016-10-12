defmodule KlziiChat.DatabaseMonitoring.EventParser do
  alias KlziiChat.BackgroundTasks.{SessionTopic}

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
    spawn_link(fn ->
      Exq.enqueue(Exq, "notify", SessionTopic, [id])
    end)
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
