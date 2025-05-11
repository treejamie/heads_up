defmodule HeadsUpWeb.IncidentsLive.Show do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  on_mount({HeadsUpWeb.UserAuth, :mount_current_user})

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :form, to_form(%{}))

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
            <h3>{@incident.category.name}</h3>
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
        <div class="left">
          <div :if={@incident.status == :pending}>
            <%= if @current_user do %>
            <.form for={@form} id="response-form">
            <.input
              field={@form[:status]}
              type="select"
              prompt="Choose a status"
              options={[:enroute, :arrived, :departed]} />

            <.input field={@form[:note]}
              type="textarea"
              placeholder="Note..."
              autofocus />

            <.button>Post</.button>
          </.form>
          <% else %>
            <.link href={~p"/users/log_in"} class="button">
              Log In To Post
            </.link>
          <% end %>

          </div>


        </div>
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
