defmodule Kekoverflow.Repo.Migrations.UpdateQuestionsTable do
  use Ecto.Migration

  def change do
    alter table("questions") do
      add :best_answer_id, :integer
    end
  end
end
