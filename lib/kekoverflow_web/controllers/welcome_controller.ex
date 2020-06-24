defmodule KekoverflowWeb.WelcomeController do
  use KekoverflowWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.question_path(conn, :index))
  end
end
