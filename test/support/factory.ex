defmodule Kekoverflow.Factory do
  use ExMachina.Ecto, repo: Kekoverflow.Repo
  alias Kekoverflow.{Questions.Question, Questions.Tag, Questions, Answers.Answer, Answers, Comments.Comment, Comments, Users.User}

  def user_factory do
    %User{
      email: Faker.Internet.email(),
      role: "user"
    }
  end

  def admin_factory do
    %User{
      email: Faker.Internet.email(),
      role: "admin"
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
      user: build(:user)
    }
  end

  def comment_factory do
    %Comment{
      body: Faker.Lorem.Shakespeare.En.romeo_and_juliet(),
      user: build(:user)
    }
  end

  def comment_for_question_factory do
    %Comment{
      body: Faker.Lorem.Shakespeare.En.romeo_and_juliet(),
      user: build(:user),
      question: build(:question)
    }
  end

  def comment_for_answer_factory do
    %Comment{
      body: Faker.Lorem.Shakespeare.En.romeo_and_juliet(),
      user: build(:user),
      question: build(:question),
      answer: build(:answer)
    }
  end

  def tag_factory do
    %Tag{
      text: "elixir",
      questions: []
    }
  end

  def answer_with_assoc_factory do
    %Answer{
      body: Faker.Lorem.Shakespeare.En.romeo_and_juliet(),
      rate: 1,
      user: build(:user),
      question: build(:question)
    }
  end

  def question_with_assoc_factory do
    %Question{
      title: Faker.Superhero.name(),
      body: Faker.Lorem.Shakespeare.hamlet(),
      rate: 2,
      user: build(:user),
      answers: [build(:answer)],
      tags: [],
      comments: []
    }
  end
end