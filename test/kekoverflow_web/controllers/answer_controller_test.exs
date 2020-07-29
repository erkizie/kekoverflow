defmodule KekoverflowWeb.AnswerControllerTest do
  use KekoverflowWeb.ConnCase
  import Kekoverflow.Factory
  alias Kekoverflow.Answers

  @create_attrs %{body: "some body", rate: 42}
  @update_attrs %{body: "some updated body", rate: 43}
  @invalid_attrs %{body: nil, rate: nil}

  setup %{conn: conn} do
    user = insert(:user)
    question = insert(:question)
    answer = insert(:answer_with_assoc, question: question, user: user)
    {:ok, conn: assign(conn, :current_user, user), answer: answer, question: question}
  end

  describe "create answer" do
    test "redirects to question page when data is valid", %{conn: conn, question: question} do
      conn = post(conn, Routes.question_answer_path(conn, :create, question), answer: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)

      conn = recycle_conn(conn)

      conn = get(conn, Routes.question_path(conn, :show, question))
      assert html_response(conn, 200) =~ "Kekoverflow"
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = post(conn, Routes.question_answer_path(conn, :create, question), answer: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong! Please check the errors below."
    end
  end

  describe "edit answer" do
    test "renders form for editing chosen answer", %{conn: conn, answer: answer, question: question} do
      conn = get(conn, Routes.question_answer_path(conn, :edit, question, answer))
      assert html_response(conn, 200) =~ "Edit Answer"
    end
  end

  describe "update answer" do
    test "redirects when data is valid", %{conn: conn, answer: answer, question: question} do
      conn = put(conn, Routes.question_answer_path(conn, :update, question, answer), answer: @update_attrs)
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)

      conn = recycle_conn(conn)

      conn = get(conn, Routes.question_path(conn, :show, question))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, answer: answer, question: question} do
      conn = put(conn, Routes.question_answer_path(conn, :update, question, answer), answer: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Answer"
    end
  end

  describe "delete answer" do
    test "deletes chosen answer", %{conn: conn, answer: answer, question: question} do
      conn = delete(conn, Routes.question_answer_path(conn, :delete, question, answer))
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)
    end
  end

  defp recycle_conn(conn) do
    saved_assigns = conn.assigns
    conn =
      conn
      |> recycle()
      |> Map.put(:assigns, saved_assigns)
    conn
  end
end
