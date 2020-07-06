defmodule Kekoverflow.Repo.Migrations.AddRolesForUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :role, :string, default: "user"
    end
  end
end
