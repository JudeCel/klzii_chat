defmodule KlziiChat.DatabaseMonitoring.EventParser do
  alias KlziiChat.BackgroundTasks.{SessionTopic, Invites}

  @spec messages() :: Map.t
  def messages do
    %{
      errors: %{
        unhandle_event: "unhandle channel event"
      }
    }
  end

  @spec save_event(Tuple.t) :: {:ok, String.t} | {:error, String.t}
  def save_event({:ok, queue, module, arrgs}) do
    case Mix.env do
      :test ->
        {:ok, "Running in Test ENV"}
      _ ->
        spawn_link(fn ->
          Exq.enqueue(Exq, queue, module, arrgs)
        end)
    end
  end
  def save_event({:error, message}) do
    {:error, message}
  end

  def processe_event(channel, payload) do
    decode_message(channel, payload)
    |> select_job
    |> build_enqueue
    |> save_event
  end

  @spec decode_message(String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  def decode_message(_, payload) do
    Poison.decode!(payload)
  end

  def build_enqueue({:ok, :session_topics, arrgs}) do
    {:ok, "notify", SessionTopic, arrgs}
  end
  def build_enqueue({:ok, :invites, arrgs}) do
    {:ok, "notify", Invites, arrgs}
  end
  def build_enqueue({:error, message}) do
    {:error, message}
  end

  @spec select_job(Map.t) :: {:ok, String.t} | {:error, String.t}
  def select_job(job_params) do
    case job_params do
      %{"table" =>  "SessionTopics", "data" =>  %{"sessionId" => session_id}} ->
        {:ok, :session_topics, [session_id]}
      %{"table" =>  "Invites", "data" =>  %{"id" =>  id }} ->
        {:ok, :invites, [id]}
      _ ->
        {:error, messages.errors.unhandle_event}
    end
  end
end
