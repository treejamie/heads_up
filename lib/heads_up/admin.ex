defmodule HeadsUp.Admin do

  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  def list_incidents() do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
