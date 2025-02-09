defmodule Hook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: Hook.Plugs.Router, scheme: :http, port: 6007}
      # Starts a worker by calling: Hook.Worker.start_link(arg)
      # {Hook.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hook.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
