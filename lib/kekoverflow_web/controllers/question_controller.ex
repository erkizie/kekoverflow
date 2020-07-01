defmodule KekoverflowWeb.QuestionController do
  use KekoverflowWeb, :controller
  use Ecto.Schema
  require IEx

  alias Kekoverflow.{Repo, Questions.Question, Questions, Answers.Answer, Answers, Comments.Comment, Comments}

  def index(conn, _params) do
    questions = Questions.list_questions()
    render(conn, "index.html", questions: questions)
  end

  def new(conn, _params) do
    changeset = Questions.change_question(%Question{})
    render(conn, "new.html", changeset: changeset, tags: [])
  end

  def create(conn, %{"question" => question_params}) do
    user = conn.assigns.current_user

    tags = String.split(question_params["add_tags"], ", ")

    changeset = user
      |> Ecto.build_assoc(:questions)
      |> Question.changeset(question_params)

#    changeset = Question.changeset(%Question{user_id: user.id}, question_params)

    case Repo.insert(changeset) do
      {:ok, question} ->
      Enum.each(tags, fn tag -> Questions.add_tag(question, tag) end)
        conn
        |> put_flash(:info, "Successfully created")
        |> redirect(to: Routes.question_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    question = Questions.get_question!(id)

    answers = for answer <- question.answers do
                answer |> Repo.preload(:comments)
              end

    answer_changeset = question
                        |> Ecto.build_assoc(:answers)
                        |> Answer.changeset()

    comment_changeset = question
                        |> Ecto.build_assoc(:answers)
                        |> Ecto.build_assoc(:comments)
                        |> Comment.changeset()

    render(conn, "show.html", question: question, answers: answers, answer_changeset: answer_changeset, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    question = Questions.get_question!(id)
    changeset = Questions.change_question(question)
    render(conn, "edit.html", question: question, changeset: changeset)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Questions.get_question!(id)

    case Questions.update_question(question, question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: Routes.question_path(conn, :show, question))

      {:error, changeset} ->
        render(conn, "edit.html", question: question, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Questions.get_question!(id)
    {:ok, _question} = Questions.delete_question(question)

    conn
    |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: Routes.question_path(conn, :index))
  end
end
