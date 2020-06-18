defmodule Kekoverflow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Kekoverflow.Repo,
      # Start the Telemetry supervisor
      KekoverflowWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Kekoverflow.PubSub},
      # Start the Endpoint (http/https)
      KekoverflowWeb.Endpoint
      # Start a worker by calling: Kekoverflow.Worker.start_link(arg)
      # {Kekoverflow.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kekoverflow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    KekoverflowWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
