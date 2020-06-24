defmodule Kekoverflow.Answers.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kekoverflow.Answers.Answer

  schema "answers" do
    field :body, :string
    field :rate, :integer

    belongs_to :user, Kekoverflow.Users.User
    belongs_to :question, Kekoverflow.Questions.Question

    timestamps()
  end

  @doc false
  def changeset(answer, attrs \\ %{}) do
    answer
    |> cast(attrs, [:body, :rate])
    |> validate_required([:body])
  end
end
