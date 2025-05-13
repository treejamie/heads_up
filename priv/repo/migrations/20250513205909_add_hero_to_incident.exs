defmodule HeadsUp.Repo.Migrations.AddHeroToIncident do
  use Ecto.Migration

  def change do
    alter table(:incidents) do
      add :heroic_response_id, references(:incidents, on_delete: :nilify_all)
    end

    create index(:incidents, [:heroic_response_id])


  end
end
