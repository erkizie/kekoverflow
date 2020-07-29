defmodule KekoverflowWeb.CommentController do
  use KekoverflowWeb, :controller

  alias Kekoverflow.{Repo, Questions.Question, Answers.Answer, Comments.Comment, Comments}

  action_fallback KekoverflowWeb.FallbackController

  def create(conn, %{"comment" => comment_params, "question_id" => question_id, "answer_id" => answer_id}) do
    question = Repo.get!(Question, question_id) |> Repo.preload([:user, :answers, :comments, :tags])

    user = conn.assigns.current_user
    answer_id = String.to_integer(answer_id)
    question_id = String.to_integer(question_id)

    answers = prepare_answers(question)
    best_answer = prepare_best_answer(question)
    answer_changeset = prepare_answer_changeset(question)

    changeset = Comment.changeset(%Comment{user_id: user.id, question_id: question_id, answer_id: answer_id}, comment_params)
    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))

      {:error, changeset} ->
        render(conn, KekoverflowWeb.QuestionView, "show.html", question: question, answers: answers, answer_changeset: answer_changeset, comment_changeset: changeset, best_answer: best_answer)
    end
  end

  def create(conn, %{"comment" => comment_params, "question_id" => question_id}) do
    question = Repo.get!(Question, question_id) |> Repo.preload([:user, :answers, :comments, :tags])

    user = conn.assigns.current_user
    question_id = String.to_integer(question_id)

    answers = prepare_answers(question)
    best_answer = prepare_best_answer(question)
    answer_changeset = prepare_answer_changeset(question)

    changeset = Comment.changeset(%Comment{user_id: user.id, question_id: question_id}, comment_params)
    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))

      {:error, changeset} ->
        render(conn, KekoverflowWeb.QuestionView, "show.html", question: question, answers: answers, answer_changeset: answer_changeset, comment_changeset: changeset, best_answer: best_answer)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    question = Repo.get(Question, comment.question_id)
    user = conn.assigns.current_user

    with :ok <- Bodyguard.permit(Comments, :delete_comment, user, comment),
         {:ok, _comment} <- Comments.delete_comment(comment)
      do
      conn
      |> put_flash(:info, "Comment deleted successfully.")
      |> redirect(to: Routes.question_path(conn, :show, question))
    end
  end

  defp prepare_answers(question) do
    answers = for answer <- question.answers do
      answer |> Repo.preload(:comments)
    end
  end

  defp prepare_best_answer(question) do
    best_answer =
      if question.best_answer_id do
        Answers.get_answer!(question.best_answer_id)
        |> Repo.preload(:comments)
      else
        nil
      end
  end

  defp prepare_answer_changeset(question) do
    answer_changeset = question
                       |> Ecto.build_assoc(:answers)
                       |> Answer.changeset()
  end
end
