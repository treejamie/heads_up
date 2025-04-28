defmodule HeadsUp.Incidents do

  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  @spec list_incidents() :: [
          %Incident{
            description: <<_::392, _::_*64>>,
            id: 1 | 2 | 3,
            image_path: <<_::64, _::_*8>>,
            name: <<_::64, _::_*8>>,
            priority: 1 | 2,
            status: :canceled | :pending | :resolved
          },
          ...
        ]
  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents(filter) do
    Incident
    |> where(status: ^filter["status"])
    |> where([r], ilike(r.name, ^"%#{filter["q"]}%"))
    |> IO.inspect
    |> order_by(desc: :name)
    |> Repo.all()
  end


  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def get_urgent(incident) do
    Incident
    |> where(status: :pending)
    |> where([r], r.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
