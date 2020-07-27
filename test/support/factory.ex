defmodule Kekoverflow.Factory do
  use ExMachina.Ecto, repo: Kekoverflow.Repo
  alias Kekoverflow.{Questions.Question, Questions, Answers.Answer, Answers, Comments.Comment, Comments, Users.User}

  def user_factory do
    %User{
      email: Faker.Internet.email(),
      role: "user",
      password: "qwerty123"
    }
  end

  def question_factory do
    %Question{
      title: Faker.Superhero.name(),
      body: Faker.Lorem.Shakespeare.hamlet(),
      rate: 2,
      user: build(:user)
    }
  end

  def answer_factory do
    %Answer{
      body: Faker.Lorem.Shakespeare.En.romeo_and_juliet(),
      rate: 1,
      user: build(:user),
      question: build(:question)
    }
  end
end