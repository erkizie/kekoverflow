defmodule Kekoverflow.Repo.Migrations.CreateQuestionsRate do
  use Ecto.Migration

  def change do
    create table(:questions_rate) do
      add :rate, :integer
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end

    create index(:questions_rate, [:question_id])
  end
end
