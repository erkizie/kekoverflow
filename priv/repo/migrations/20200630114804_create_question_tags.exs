defmodule Kekoverflow.Repo.Migrations.CreateQuestionTags do
  use Ecto.Migration

  def change do
    create table(:question_tags) do
      add :question_id, references(:questions, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end

    create index(:question_tags, [:question_id])
    create index(:question_tags, [:tag_id])
  end
end
