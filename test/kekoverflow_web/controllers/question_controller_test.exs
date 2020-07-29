defmodule KekoverflowWeb.QuestionControllerTest do
  use KekoverflowWeb.ConnCase
  import Kekoverflow.Factory
  alias Kekoverflow.Questions

  @create_attrs %{body: "some body", rate: 42, title: "some title", add_tags: "elixir"}
  @update_attrs %{body: "some updated body", rate: 43, title: "some updated title"}
  @invalid_attrs %{body: nil, rate: nil, title: nil}

  setup %{conn: conn} do
    user = insert(:user)
    question = insert(:question_with_assoc, user: user)
    {:ok, conn: assign(conn, :current_user, user), question: question}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, Routes.question_path(conn, :index))
      assert html_response(conn, 200) =~ "Kekoverflow"
    end
  end

  describe "new question" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.question_path(conn, :new))
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "create question" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.question_path(conn, :create), question: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.question_path(conn, :show, id)

      conn = recycle_conn(conn)

      conn = get(conn, Routes.question_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Kekoverflow"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.question_path(conn, :create), question: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Question"
    end
  end

  describe "edit question" do
    test "renders form for editing chosen question", %{conn: conn, question: question} do
      conn = get(conn, Routes.question_path(conn, :edit, question))
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "update question" do
    test "redirects when data is valid", %{conn: conn, question: question} do
      conn = put(conn, Routes.question_path(conn, :update, question), question: @update_attrs)
      assert redirected_to(conn) == Routes.question_path(conn, :show, question)

      conn = recycle_conn(conn)

      conn = get(conn, Routes.question_path(conn, :show, question))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, Routes.question_path(conn, :update, question), question: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Question"
    end
  end

  describe "delete question" do
    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, Routes.question_path(conn, :delete, question))
      assert redirected_to(conn) == Routes.question_path(conn, :index)
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
