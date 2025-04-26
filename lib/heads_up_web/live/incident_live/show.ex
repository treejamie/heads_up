defmodule HeadsUpWeb.IncidentsLive.Show do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident!(id)
    socket =
      socket
      |> assign(:incident, incident)
      |> assign(:urgent_incidents, Incidents.get_urgent(incident))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-show">
      <div class="incident">
        <img src={@incident.image_path} />
        <section>
          <.badge status={@incident.status} />
          <header>
            <h2>{@incident.name}</h2>
            <div class="priority">
            {@incident.priority}
            </div>
          </header>
          <div class="description">
          {@incident.description}
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.urgent_incidents incidents={@urgent_incidents} />
        </div>
      </div>
    </div>
    """
  end

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <ul class="incidents">
          <li :for={incident <- @incidents}>
          <.link navigate={~p"/incidents/#{incident}"}>
              <img src={incident.image_path}>
              {incident.name}
            </.link>
          </li>
      </ul>
    </section>
    """
  end
end
