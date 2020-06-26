defmodule Kekoverflow.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :body, :string
    field :rate, :integer
    field :title, :string

    belongs_to :user, Kekoverflow.Users.User
    has_many :answers, Kekoverflow.Answers.Answer
    has_many :comments, Kekoverflow.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(question, attrs \\ %{}) do
    question
    |> cast(attrs, [:title, :body, :rate])
    |> validate_required([:title, :body])
  end
end
