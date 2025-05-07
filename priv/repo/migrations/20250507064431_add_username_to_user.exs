defmodule HeadsUp.Repo.Migrations.AddUsernameToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
    end

    create unique_index(:users, [:username]) # note: email already has an index from generated scaffold code

  end
end
