defmodule Kekoverflow.QuestionsTest do
  use Kekoverflow.DataCase
  import Kekoverflow.Factory
  alias Kekoverflow.Questions

  describe "questions" do
    alias Kekoverflow.Questions.Question

    setup do
      question = insert(:question_with_assoc)
      {:ok, question: question}
    end

    @valid_attrs %{body: "some body", rate: 42, title: "some title"}
    @update_attrs %{body: "some updated body", rate: 43, title: "some updated title"}
    @invalid_attrs %{body: nil, rate: nil, title: nil}

    test "list_questions/0 returns all questions", %{question: question} do
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id", %{question: question} do
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Questions.create_question(@valid_attrs)
      assert question.body == "some body"
      assert question.rate == 42
      assert question.title == "some title"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question", %{question: question} do
      assert {:ok, %Question{} = question} = Questions.update_question(question, @update_attrs)
      assert question.body == "some updated body"
      assert question.rate == 43
      assert question.title == "some updated title"
    end

    test "update_question/2 with invalid data returns error changeset", %{question: question} do
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question", %{question: question} do
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset", %{question: question} do
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end

  describe "tags" do
    alias Kekoverflow.Questions.Tag

    setup do
      tag = insert(:tag)
      {:ok, tag: tag}
    end

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    test "list_tags/0 returns all tags", %{tag: tag} do
      assert Questions.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id", %{tag: tag} do
      assert Questions.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Questions.create_tag(@valid_attrs)
      assert tag.text == "some text"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag", %{tag: tag} do
      assert {:ok, %Tag{} = tag} = Questions.update_tag(tag, @update_attrs)
      assert tag.text == "some updated text"
    end

    test "update_tag/2 with invalid data returns error changeset", %{tag: tag} do
      assert {:error, %Ecto.Changeset{}} = Questions.update_tag(tag, @invalid_attrs)
      assert tag == Questions.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag", %{tag: tag} do
      assert {:ok, %Tag{}} = Questions.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset", %{tag: tag} do
      assert %Ecto.Changeset{} = Questions.change_tag(tag)
    end
  end
end
