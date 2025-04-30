defmodule HeadsUp.Admin do

  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  def list_incidents() do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_incident(attrs \\ %{} ) do
   %Incident{
    name: attrs["name"],
    priority: attrs["priority"] |> String.to_integer(),
    status: attrs["status"] |> String.to_existing_atom(),
    description: attrs["description"],
    image_path: attrs["image_path"],
   }
   |> Repo.insert!()
  end
end
