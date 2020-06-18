defmodule Kekoverflow.Answers.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :body, :string
    field :rate, :integer
    field :title, :string
    field :user_id, :id
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:title, :body, :rate])
    |> validate_required([:title, :body, :rate])
  end
end
