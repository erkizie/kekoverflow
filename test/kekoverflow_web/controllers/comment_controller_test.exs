defmodule KekoverflowWeb.CommentControllerTest do
  use KekoverflowWeb.ConnCase
  import Kekoverflow.Factory
  alias Kekoverflow.Comments

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  setup %{conn: conn} do
    user = insert(:user)
    question = insert(:question)
    answer = insert(:answer)

    comment_for_question = insert(:comment_for_question, question: question, user: user)
    comment_for_answer = insert(:comment_for_answer, question: question, answer: answer, user: user)
    {:ok, conn: assign(conn, :current_user, user), comment_for_question: comment_for_question, comment_for_answer: comment_for_answer, question: question, answer: answer}
  end

  describe "create comment for question" do
    test "redirects to show when data is valid", %{conn: conn, question: question} do
      conn = post(conn, Routes.question_comment_path(conn, :create, question), comment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = post(conn, Routes.question_comment_path(conn, :create, question), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong! Please check the errors below."
    end
  end

  describe "create comment for answer" do
    test "redirects to show when data is valid", %{conn: conn, question: question, answer: answer} do
      conn = post(conn, Routes.question_answer_comment_path(conn, :create, question, answer), comment: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)
    end

    test "renders errors when data is invalid", %{conn: conn, question: question, answer: answer} do
      conn = post(conn, Routes.question_answer_comment_path(conn, :create, question, answer), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "Oops, something went wrong! Please check the errors below."
    end
  end

  describe "delete comment for question" do
    test "deletes chosen comment", %{conn: conn, comment_for_question: comment, question: question} do
      conn = delete(conn, Routes.question_comment_path(conn, :delete, question, comment))
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)
    end
  end

  describe "delete comment for answer" do
    test "deletes chosen comment", %{conn: conn, comment_for_answer: comment, question: question, answer: answer} do
      conn = delete(conn, Routes.question_answer_comment_path(conn, :delete, question, answer, comment))
      IO.inspect(conn)
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)
    end
  end
end
