defmodule HeadsUp.Incidents do

  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def list_responses(incident) do
    incident
    |> Ecto.assoc(:responses)
    |> preload(:user)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> with_order(filter["sort_by"])
    |> with_category(filter["category"])
    |> search_by(filter["q"])
    |> preload(:category)
    |> Repo.all()
  end

  defp with_category(query, slug) when slug in ["", nil], do: query
  defp with_category(query, slug) do
    from r in query,
    join: c in assoc(r, :category),
    where: c.slug == ^slug

  end


  defp search_by(query, q) when q in ["", nil], do: query
  defp search_by(query, q) do
    where(query, [r], ilike(r.name, ^"%#{q}%"))
  end


  defp with_order(query, "priority_asc"), do: order_by(query, [asc: :priority])
  defp with_order(query, "priority_desc"), do: order_by(query, [desc: :priority])
  defp with_order(query, "name"), do: order_by(query, :name)
  defp with_order(query, "category")  do
    from r in query,
    join: c in assoc(r, :category),
    order_by: c.name

  end
  defp with_order(query, _), do: order_by(query, :id)


  defp with_status(query, status) when status in ~w(canceled pending resolved) do
    where(query, status: ^status)
  end
  defp with_status(query, _), do: query

  def get_incident!(id) do
    Repo.get!(Incident, id)
    |> Repo.preload(:category)
  end

  def get_urgent(incident) do
    # simulate a very slow query
    Process.sleep(200)

    Incident
    |> where(status: :pending)
    |> where([r], r.id != ^incident.id)
    |> order_by(asc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
