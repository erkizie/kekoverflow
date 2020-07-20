defmodule KekoverflowWeb.FallbackController do
  use KekoverflowWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(:error, "You are not authorized")
    |> redirect(to: Routes.question_path(conn, :index))
  end
end