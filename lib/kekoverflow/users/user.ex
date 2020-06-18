defmodule Kekoverflow.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :questions, Kekoverflow.Questions.Question

    timestamps()
  end
end
