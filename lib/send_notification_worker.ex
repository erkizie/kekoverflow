defmodule Kekoverflow.SendNotificationWorker do
  def perform(message) do
    IO.puts("Done. Message: #{message["title"]} has been created")
  end
end