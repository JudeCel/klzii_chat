defmodule KlziiChat do
  use Application
  alias KlziiChat.{Endpoint, Repo, Presence}
  alias KlziiChat.Dashboard.Presence, as: DashboardPresence

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Endpoint, []),
      # Start the Ecto repository
      supervisor(Repo, []),
      supervisor(Presence, []),
      supervisor(DashboardPresence, []),
      supervisor(Task.Supervisor, [[name: KlziiChat.BackgroundTasks]]),
      supervisor(KlziiChat.DatabaseMonitoring.Listener, [])
      # Here you could define other workers and supervisors as children
      # worker(KlziiChat.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KlziiChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
