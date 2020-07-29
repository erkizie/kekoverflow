defmodule Kekoverflow.CommentsTest do
  use Kekoverflow.DataCase
  import Kekoverflow.Factory
  alias Kekoverflow.Comments

  describe "comments" do
    alias Kekoverflow.Comments.Comment

    setup do
      comment = insert(:comment)
      {:ok, comment: comment}
    end

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments", %{comment: comment} do
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id", %{comment: comment} do
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Comments.create_comment(@valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment", %{comment: comment} do
      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, @update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset", %{comment: comment} do
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment", %{comment: comment} do
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset", %{comment: comment} do
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
