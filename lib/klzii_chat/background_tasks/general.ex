defmodule KlziiChat.BackgroundTasks.General do

  def run_task(fun) do
    if Mix.env == :test do
      Task.async(fun) |> Task.await
    else
      Task.Supervisor.start_child(KlziiChat.BackgroundTasks, fun)
    end
  end
end
