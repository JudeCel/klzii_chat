defmodule KlziiChat.BackgroundTasks.Resources do
  alias KlziiChat.Services.{ResourceService}
  alias KlziiChat.BackgroundTasks.{General}

  def tidy_up(resources)  do
    Enum.map(resources, fn(item) ->
      General.run_task(fn -> ResourceService.clean_up_all_relations(item)end)
    end)
  end
end
