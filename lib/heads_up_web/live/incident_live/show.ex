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
      |> assign_async(:urgent_incidents, fn  ->
        {:ok, %{urgent_incidents: Incidents.get_urgent(incident)}}
        # {:error, "full of owls 🦉"}
      end )

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
      <.async_result :let={result} assign={@incidents}>
        <:loading>
          <div class="loading">
            <div class="spinner"></div>
          </div>
        </:loading>

        <:failed :let={{:error, reason}}>
        <div class="failed">
            {reason}
          </div>
        </:failed>

        <ul class="incidents">
            <li :for={incident <- result}>
            <.link navigate={~p"/incidents/#{incident}"}>
                <img src={incident.image_path}>
                {incident.name}
              </.link>
            </li>
        </ul>

      </.async_result>

    </section>
    """
  end
end
