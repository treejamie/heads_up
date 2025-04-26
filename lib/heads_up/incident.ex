
defmodule HeadsUp.Incidents do

  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident

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


  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def get_urgent(incident) do
    list_incidents() |> List.delete(incident)
  end
end
