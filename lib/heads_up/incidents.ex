defmodule HeadsUp.Incidents do

  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> with_order(filter["sort_by"])
    |> where([r], ilike(r.name, ^"%#{filter["q"]}%"))
    |> Repo.all()
  end


  defp with_order(query, "priority_asc"), do: order_by(query, [asc: :priority])
  defp with_order(query, "priority_desc"), do: order_by(query, [desc: :priority])
  defp with_order(query, "name"), do: order_by(query, :name)
  defp with_order(query, _), do: order_by(query, :id)



  defp with_status(query, status) when status in ~w(canceled pending resolved) do
    where(query, status: ^status)
  end
  defp with_status(query, _), do: query


  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  def get_urgent(incident) do
    # simulate a very slow query
    Process.sleep(3000)

    Incident
    |> where(status: :pending)
    |> where([r], r.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
