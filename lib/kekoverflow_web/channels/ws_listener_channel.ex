defmodule KekoverflowWeb.WsListenerChannel do
  use KekoverflowWeb, :channel

  @impl true
  def join("ws_listener:lobby", payload, socket) do
    {:ok, %{welcome: "Ah shit, here we go again"}, socket}
  end
end
