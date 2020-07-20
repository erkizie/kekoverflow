defmodule KekoverflowWeb.AnswerController do
  use KekoverflowWeb, :controller
  import Ecto
  import Kekoverflow.Authorization

  alias Kekoverflow.{Repo, Answers.Answer, Answers, Questions, Questions.Question}

  require IEx

  def create(conn, %{"answer" => answer_params, "question_id" => question_id}) do
    user = conn.assigns.current_user
    question = Repo.get!(Question, question_id) |> Repo.preload([:user, :answers])

#    changeset = question
#      |> Ecto.build_assoc(:answers)
#      |> Answer.changeset(answer_params)

    changeset = Answer.changeset(%Answer{user_id: user.id, question_id: String.to_integer(question_id)}, answer_params)

    case Repo.insert(changeset) do
      {:ok, _answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: Routes.question_path(conn, :show, question_id))

      {:error, changeset} ->
        render(conn, KekoverflowWeb.QuestionView, "show.html", question: question, comment_changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Answers.get_answer!(id)

    case Answers.update_answer(answer, answer_params) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer updated successfully.")
        |> redirect(to: Routes.question_answer_path(conn, :show, answer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", answer: answer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Answers.get_answer!(id)

    {:ok, _answer} = Answers.delete_answer(answer)

    question = Repo.get(Question, answer.question_id)

    if id == question.best_answer_id do
        Questions.update_question(question, %{"best_answer_id" => nil})
    end

    conn
    |> put_flash(:info, "Answer deleted successfully.")
    |> redirect(to: Routes.question_path(conn, :show, question))
  end
end
