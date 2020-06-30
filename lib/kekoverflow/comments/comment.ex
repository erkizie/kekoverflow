defmodule Kekoverflow.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :user_id, :id
    field :question_id, :id
    field :answer_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:body, :user_id, :question_id, :answer_id])
    |> validate_required([:body])
  end
end
