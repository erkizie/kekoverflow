defmodule KekoverflowWeb.AnswerController do
  use KekoverflowWeb, :controller
  import Ecto

  alias Kekoverflow.{Repo, Answers.Answer, Answers, Questions, Questions.Question, Comments.Comment}

  action_fallback KekoverflowWeb.FallbackController

  def create(conn, %{"answer" => answer_params, "question_id" => question_id}) do
    user = conn.assigns.current_user
    question = Questions.get_question!(question_id) |> Repo.preload([:user, :answers])

    answers = prepare_answers(question)
    best_answer = prepare_best_answer(question)
    comment_changeset = prepare_comment_changeset(question)

    changeset = Answer.changeset(%Answer{user_id: user.id, question_id: String.to_integer(question_id)}, answer_params)

    case Repo.insert(changeset) do
      {:ok, _answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))

      {:error, changeset} ->
        render(conn, KekoverflowWeb.QuestionView, "show.html", question: question, answers: answers, answer_changeset: changeset, comment_changeset: changeset, best_answer: best_answer)
    end
  end

  def edit(conn, %{"id" => id, "question_id" => question_id}) do
    question = Questions.get_question!(question_id)
    answer = Answers.get_answer!(id)
    changeset = Answers.change_answer(answer)
    render(conn, "edit.html", answer: answer, question: question, changeset: changeset)
  end

  def update(conn, %{"id" => id, "question_id" => question_id, "rate_update" => "up"}) do
    answer = Answers.get_answer!(id)
    rate_params = %{"rate" => answer.rate + 1}

    case Answers.update_answer(answer, rate_params) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "You have upgraded this answer`s rating.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))
    end
  end

  def update(conn, %{"id" => id, "question_id" => question_id, "rate_update" => "down"}) do
    answer = Answers.get_answer!(id)
    rate_params = %{"rate" => answer.rate - 1}

    case Answers.update_answer(answer, rate_params) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "You have downgraded this answer`s rating.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))
    end
  end

  def update(conn, %{"id" => id, "answer" => answer_params, "question_id" => question_id}) do
    answer = Answers.get_answer!(id)
    question = Questions.get_question!(question_id)
    user = conn.assigns.current_user

    with :ok <- Bodyguard.permit(Answers, :update_answer, user, answer) do
      case Answers.update_answer(answer, answer_params) do
        {:ok, answer} ->
          conn
          |> put_flash(:info, "Answer updated successfully.")
          |> redirect(to: Routes.question_path(conn, :show, question))

        {:error, changeset} ->
          render(conn, "edit.html", answer: answer, question: question, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id, "question_id" => question_id}) do
    answer = Answers.get_answer!(id)
    question = Questions.get_question!(question_id)
    user = conn.assigns.current_user

    with :ok <- Bodyguard.permit(Answers, :delete_answer, user, answer),
         {:ok, _answer} <- Answers.delete_answer(answer)
      do
      if id == question.best_answer_id do
        Questions.update_question(question, %{"best_answer_id" => nil})
      end

      conn
      |> put_flash(:info, "Answer deleted successfully.")
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

  defp prepare_comment_changeset(question) do
    comment_changeset = question
                        |> Ecto.build_assoc(:answers)
                        |> Ecto.build_assoc(:comments)
                        |> Comment.changeset()
  end
end
