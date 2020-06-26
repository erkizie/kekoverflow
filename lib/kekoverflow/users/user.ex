defmodule Kekoverflow.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :questions, Kekoverflow.Questions.Question
    has_many :answers, through: [:questions, :answer]
    has_many :comments, Kekoverflow.Comments.Comment

    timestamps()
  end
end
