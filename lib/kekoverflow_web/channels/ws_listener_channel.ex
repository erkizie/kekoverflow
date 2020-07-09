defmodule KekoverflowWeb.WsListenerChannel do
  use KekoverflowWeb, :channel

  @impl true
  def join("ws_listener:lobby", payload, socket) do
    {:ok, %{welcome: "Ah shit, here we go again"}, socket}
  end

  @impl true
  def handle_in("ping", _payload, socket) do
    :timer.sleep(3000)
    {:reply, {:ok, %{elixir: "Is the beast"}}, socket}
  end
end
