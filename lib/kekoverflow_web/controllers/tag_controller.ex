defmodule KekoverflowWeb.TagController do
  use KekoverflowWeb, :controller

  alias Kekoverflow.Questions
  alias Kekoverflow.Questions.Tag

  def index(conn, _params) do
    tags = Questions.list_tags()
    render(conn, "index.html", tags: tags)
  end

  def tagged(conn, %{"tag" => tag}) do
    tag = Questions.get_tag!(tag)
    render(conn, "tagged.html", tag: tag)
  end

  def new(conn, _params) do
    changeset = Questions.change_tag(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}) do
    case Questions.create_tag(tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: Routes.tag_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Questions.get_tag!(id)
    {:ok, _tag} = Questions.delete_tag(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: Routes.tag_path(conn, :index))
  end
end
