defmodule Kekoverflow.Repo.Migrations.UpdateQuestionsTableField do
  use Ecto.Migration

  def change do
    alter table("questions") do
      modify :best_answer_id, :string
    end
  end
end
