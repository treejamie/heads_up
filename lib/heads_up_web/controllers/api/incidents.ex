defmodule HeadsUpWeb.Api.IncidentController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Admin

  def index(conn, _params) do
    render(conn, :index, incidents: Admin.list_incidents() )
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, incident: Admin.get_incident!(id) )
  end

end
