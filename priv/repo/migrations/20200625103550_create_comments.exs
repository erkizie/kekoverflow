defmodule Kekoverflow.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :question_id, references(:questions, on_delete: :nothing)
      add :answer_id, references(:answers, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:question_id])
    create index(:comments, [:answer_id])
  end
end
