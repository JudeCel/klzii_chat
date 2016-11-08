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
  def session_topics(session_id) do
    case Mix.env do
      :test ->
        {:ok, "Running in Test ENV"}
      _ ->
        spawn_link(fn ->
          Exq.enqueue(Exq, "notify", SessionTopic, [session_id])
        end)
    end
  end

  def processe_event(channel, payload) do
    decode_message(channel, payload)
    |> select_job
    |> save_event
  end

  @spec decode_message(String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  def decode_message(_, payload) do
    Poison.decode!(payload)
  end

  def save_event({:ok, module, fun, arrgs}) do
    apply(module, fun, arrgs)
  end

  @spec select_job(Map.t) :: {:ok, String.t} | {:error, String.t}
  def select_job(job_params) do
    case job_params do
      %{"table" =>  "SessionTopics", "id" =>  _, "session_id" => session_id} ->
        {:ok, __MODULE__, :session_topics, [session_id]}
      _ ->
        {:error, messages.errors.unhandle_event}
    end
  end
end
