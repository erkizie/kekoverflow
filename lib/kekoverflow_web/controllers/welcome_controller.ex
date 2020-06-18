defmodule KekoverflowWeb.WelcomeController do
  use KekoverflowWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
