defmodule Kekoverflow.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Kekoverflow.Repo,
      KekoverflowWeb.Telemetry,
      {Phoenix.PubSub, name: Kekoverflow.PubSub},
      KekoverflowWeb.Endpoint,
      KekoverflowWeb.BtcRateChannel
    ]
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
