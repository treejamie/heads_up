defmodule HeadsUp.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:category) do
      add :name, :string
      add :slug, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:category, [:slug])
    create unique_index(:category, [:name])
  end
end
