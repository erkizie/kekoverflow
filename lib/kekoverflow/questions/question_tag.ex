defmodule Kekoverflow.Questions.QuestionTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kekoverflow.Questions.{Question, QuestionTag, Tag}

  schema "question_tags" do
    belongs_to :question, Question
    belongs_to :tag, Tag

    timestamps()
  end

  @doc false
  def changeset(question_tag, attrs) do
    question_tag
    |> cast(attrs, [:question_id, :tag_id])
    |> validate_required([])
  end
end
