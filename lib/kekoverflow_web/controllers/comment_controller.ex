defmodule KekoverflowWeb.CommentController do
  use KekoverflowWeb, :controller
  import Kekoverflow.Authorization

  alias Kekoverflow.{Repo, Questions.Question, Answers.Answer, Comments.Comment, Comments}

  def create(conn, %{"comment" => comment_params, "question_id" => question_id, "answer_id" => answer_id}) do

    answer = Repo.get!(Answer, answer_id) |> Repo.preload([:user, :comments])
    question = Repo.get!(Question, question_id) |> Repo.preload([:user, :answers, :comments])

    user = conn.assigns.current_user
    answer_id = String.to_integer(answer_id)
    question_id = String.to_integer(question_id)

    changeset = Comment.changeset(%Comment{user_id: user.id, question_id: question_id, answer_id: answer_id}, comment_params)
    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, KekoverflowWeb.QuestionView, "show.html", question: question, answer: answer, comment_changeset: changeset)
    end
  end

  def create(conn, %{"comment" => comment_params, "question_id" => question_id}) do
    question = Repo.get!(Question, question_id) |> Repo.preload([:user, :answers, :comments])

    user = conn.assigns.current_user
    question_id = String.to_integer(question_id)

    changeset = Comment.changeset(%Comment{user_id: user.id, question_id: question_id}, comment_params)
    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, KekoverflowWeb.QuestionView, "show.html", question: question, comment_changeset: changeset)
    end
  end

#  def update(conn, %{"id" => id, "comment" => comment_params}) do
#    comment = Comments.get_comment!(id)
#
#    case Comments.update_comment(comment, comment_params) do
#      {:ok, comment} ->
#        conn
#        |> put_flash(:info, "Comment updated successfully.")
#        |> redirect(to: Routes.comment_path(conn, :show, comment))
#
#      {:error, %Ecto.Changeset{} = changeset} ->
#        render(conn, "edit.html", comment: comment, changeset: changeset)
#    end
#  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    {:ok, _comment} = Comments.delete_comment(comment)

    question = Repo.get(Question, comment.question_id)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.question_path(conn, :show, question))
  end
end
