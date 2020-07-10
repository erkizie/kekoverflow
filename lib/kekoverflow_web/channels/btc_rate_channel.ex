defmodule KekoverflowWeb.BtcRateChannel do
  use WebSockex
  require Logger
  alias KekoverflowWeb.QuestionController

  def start_link(_), do: WebSockex.start_link("wss://ws.coincap.io/prices?assets=bitcoin", __MODULE__, nil)

  @impl true
  def handle_connect(_conn, state) do
    Logger.info("Connected...")
    send(self(), :subscribe)
    {:ok, state}
  end

  @impl true
  def handle_frame({:text, data}, state) do
    data = Jason.decode!(data)
    KekoverflowWeb.Endpoint.broadcast("ws_listener:lobby", "rate", data)
    {:ok, state}
  end

  @impl true
  def handle_info(:subscribe, state) do
    subscribe =
      Jason.encode!(%{
        "event" => "subscribe",
        "pair" => ["XBT/USDC"],
        "subscription" => %{"name" => "*"}
      })
    {:reply, {:text, subscribe}, state}
  end

end