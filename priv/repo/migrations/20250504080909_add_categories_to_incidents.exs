defmodule HeadsUp.Repo.Migrations.AddCategoriesToIncidents do
  use Ecto.Migration

  def change do
    alter table(:incidents) do
      add(:category_id, references(:category))
    end

    create(index(:incidents, [:category_id]))
  end
end
