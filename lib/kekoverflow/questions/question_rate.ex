defmodule Kekoverflow.Questions.QuestionRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions_rate" do
    field :rate, :integer
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(question_rate, attrs) do
    question_rate
    |> cast(attrs, [:question_id, :rate])
    |> validate_required([:rate])
  end
end
