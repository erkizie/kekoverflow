defmodule Kekoverflow.AnswersTest do
  use Kekoverflow.DataCase
  import Kekoverflow.Factory
  alias Kekoverflow.Answers

  describe "answers" do
    alias Kekoverflow.Answers.Answer

    setup do
      answer = insert(:answer_with_assoc)
      {:ok, answer: answer}
    end

    @valid_attrs %{body: "some body", rate: 1}
    @update_attrs %{body: "some updated body", rate: 3}
    @invalid_attrs %{body: nil, rate: nil}

    test "get_answer!/1 returns the answer with given id", %{answer: answer} do
      assert Answers.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Answers.create_answer(@valid_attrs)
      assert answer.body == "some body"
      assert answer.rate == 1
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Answers.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer", %{answer: answer} do
      assert {:ok, %Answer{} = answer} = Answers.update_answer(answer, @update_attrs)
      assert answer.body == "some updated body"
      assert answer.rate == 3
    end

    test "update_answer/2 with invalid data returns error changeset", %{answer: answer} do
      assert {:error, %Ecto.Changeset{}} = Answers.update_answer(answer, @invalid_attrs)
      assert answer == Answers.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer", %{answer: answer} do
      assert {:ok, %Answer{}} = Answers.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Answers.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset", %{answer: answer} do
      assert %Ecto.Changeset{} = Answers.change_answer(answer)
    end
  end
end
