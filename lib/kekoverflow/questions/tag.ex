defmodule Kekoverflow.Questions.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kekoverflow.Questions.{Tag, Question}

  schema "tags" do
    field :text, :string
    many_to_many :questions, Question, join_through: "question_tags", on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
