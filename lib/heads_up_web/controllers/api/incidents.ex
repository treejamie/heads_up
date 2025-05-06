defmodule HeadsUpWeb.Api.IncidentController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Admin

  def index(conn, _params) do
    render(conn, :index, incidents: Admin.list_incidents() )
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, incident: Admin.get_incident!(id) )
  end

  def create(conn, %{"incident" => incident_params}) do
    case Admin.create_incident(incident_params) do
      {:ok, incident} ->
        conn
        |> put_status(:created)
        |> put_resp_header("Location", ~p"/api/incidents/#{incident.id}")
        |> render(:show, incident: incident)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

end
