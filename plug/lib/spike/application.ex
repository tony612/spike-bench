defmodule Spike.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Spike.Instrumenter.setup()
    Spike.MetricsExporter.setup()

    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Spike.Router, [], [port: Application.get_env(:spike, :port)])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spike.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
