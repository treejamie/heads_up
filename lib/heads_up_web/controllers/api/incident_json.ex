defmodule HeadsUpWeb.Api.IncidentJSON do


  def index(%{incidents: incidents}) do
    Enum.map(incidents, fn incident-> data(incident) end)
  end

  def show(%{incident: incident}) do
    data(incident)
  end

  defp data(incident) do
    %{
      name: incident.name,
      priority: incident.priority,
      status: incident.status,
      description: incident. description,
      category_id: incident.category_id
    }
  end

end
