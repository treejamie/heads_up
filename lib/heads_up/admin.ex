defmodule HeadsUp.Admin do

  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  def list_incidents() do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def update_incident(%Incident{} = incident, attrs ) do
    incident
    |> change_incident(attrs)
    |> Repo.update()
  end

  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    Incident.changeset(incident, attrs)
  end

  def create_incident(attrs \\ %{} ) do
   %Incident{}
   |> Incident.changeset(attrs)
   |> Repo.insert()
  end

  def delete_incident(%Incident{} = incident) do
    Repo.delete(incident)
  end
end
