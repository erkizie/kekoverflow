defmodule Kekoverflow.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string

    belongs_to :user, Kekoverflow.Users.User
    belongs_to :question, Kekoverflow.Questions.Question
    belongs_to :answer, Kekoverflow.Answers.Answer

    timestamps()
  end

  @doc false
  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:body, :user_id, :question_id, :answer_id])
    |> validate_required([:body])
  end
end
