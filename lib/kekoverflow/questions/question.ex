defmodule Kekoverflow.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset
  require IEx

  schema "questions" do
    field :body, :string
    field :title, :string
    field :best_answer_id, :string

    belongs_to :user, Kekoverflow.Users.User
    has_many :answers, Kekoverflow.Answers.Answer, on_delete: :delete_all
    has_many :comments, Kekoverflow.Comments.Comment, on_delete: :delete_all
    many_to_many :tags, Kekoverflow.Questions.Tag, join_through: "question_tags", on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(question, attrs \\ %{}) do
    IEx.pry
    question
    |> cast(attrs, [:title, :body, :user_id, :best_answer_id])
    |> validate_required([:title, :body])
  end
end
