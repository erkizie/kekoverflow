defmodule Kekoverflow.Repo.Migrations.RemoveTitleFromAnswers do
  use Ecto.Migration

  def change do
    alter table("answers") do
      remove :title
    end
  end
end
