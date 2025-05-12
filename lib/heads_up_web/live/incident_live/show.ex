defmodule HeadsUpWeb.IncidentsLive.Show do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  alias HeadsUp.Responses
  alias HeadsUp.Responses.Response

  on_mount({HeadsUpWeb.UserAuth, :mount_current_user})

  def mount(_params, _session, socket) do
    changeset = Responses.change_response(%Response{}, %{})
    socket = assign(socket, :form, to_form(changeset))
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
            <.simple_form for={@form} id="response-form" phx-change="validate" phx-submit="save">
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
          </.simple_form>
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

  def handle_event("validate", %{"response" => response_params }, socket) do

    changeset = Responses.change_response(%Response{}, response_params)

    socket = assign(socket, :form, to_form(changeset))

    {:noreply, socket}
  end

  def handle_event("save", %{"response" => response_params }, socket) do

    %{current_user: user, incident: incident} = socket.assigns

    case Responses.create_response(user, incident, response_params) do
      {:ok, _response} ->
        changeset = Responses.change_response(%Response{})
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end

  end


end
